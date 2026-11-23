class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://github.com/pnpm/pnpm/archive/refs/tags/v12.23.0.tar.gz"
  sha256 "3ba7d8b386d31406cc95bc35a0b8495188a0846e1943b0af3b48d7ce9a9f1a6e"
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
    manifest_sha256 "4c2dd80eb1df229e9b48c9d35b4ecf09a2996e9c41ec1b238f5863b6d750d9cf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb62ee7f60c6945af48f2636a4ee1b064e197d2d749187825187a4fd2121a2a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06f2a09bb149a22c79732713ca9367607f2bc95aa52440f2c98d9c89853b6126"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a6f78e519dd61bbe9f2f025981ef8c7495a6712537e098353851d139e118dad"
    sha256 cellar: :any,                 arm64_linux:       "38eea139fe595e71e3375853a19859e031954fe1394095fd892b0ed2a209175e"
    sha256 cellar: :any,                 x86_64_linux:      "d4b8bc598c204d3c24305711eaeefa2423f72d483757d0c11c980df6621f9cef"
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
