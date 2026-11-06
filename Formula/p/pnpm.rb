class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://github.com/pnpm/pnpm/archive/refs/tags/v12.18.0.tar.gz"
  sha256 "1e5c9587b93e85d18cf405992c0748bab89558ac139f5c87d7d010aa88b85822"
  license "MIT"
  compatibility_version 1
  head "https://github.com/pnpm/pnpm.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c355c3b5e12a294769abc9a993aff1155a0e356d5d30479ed4d204c76f5cb1e1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab2e89da0d2690004c5c2e556bbc9d40ca6e9c684c23d8d56c5132314e7686c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "106af73b81d82fdad156cec23dd58c79edf071d24af8e5dd9bddce43d6be959d"
    sha256 cellar: :any,                 arm64_linux:       "c3deab1d8ea9b3909f7f579f3f315997aa7e0bf1c3af88b1e10b45679bab3bb1"
    sha256 cellar: :any,                 x86_64_linux:      "60432a81e3289f4e126b87e2454d516ee54c14a4375b385d6318e010e7166828"
  end

  depends_on "esbuild" => :build
  depends_on "node" => :build
  depends_on "rust" => :build

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  deny_network_access!

  def fetch
    rm ".cargo/config.toml"
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "pnpm/esm-loader" do
      inreplace "package.json" do |s|
        s.gsub! '"enhanced-resolve": "catalog:"', '"enhanced-resolve": "5.26.0"'
        s.gsub! '"esbuild": "catalog:"', "\"esbuild\": \"#{Formula["esbuild"].version}\""
      end
      system "npm", "install", "--workspaces=false", "--omit=optional",
                    *std_npm_args(prefix: false)
    end
  end

  def install
    ENV["ESBUILD_BINARY_PATH"] = formula_opt_bin("esbuild")/"esbuild"
    system "node", "pnpm/esm-loader/scripts/bundle-runtime.mjs"

    system "cargo", "install", *std_cargo_args(path: "pnpm/crates/cli")

    # Upstream ships these beside the binary as shell scripts rather than
    # symlinks: the `dlx` injection for `pnpx`/`pnx` matches on the name of
    # the resolved `current_exe`, which a symlink would report as `pnpm`.
    { "pn" => [], "pnpx" => ["dlx"], "pnx" => ["dlx"] }.each do |name, args|
      (bin/name).write_env_script opt_bin/"pnpm", *args, {}
    end

    generate_completions_from_executable(bin/"pnpm", "completion")
  end

  test do
    # `pnpm init` writes a `packageManager` pin naming this exact pnpm, and
    # every later invocation resolves that pin against the registry, so
    # anything that must run without network has to come first.
    assert_match version.to_s, shell_output("#{bin}/pn --version")

    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
