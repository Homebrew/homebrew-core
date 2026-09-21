class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://github.com/pnpm/pnpm/archive/refs/tags/v12.5.1.tar.gz"
  sha256 "51bddb1a98de3a4e0f2d731c723f2365da6672ebe5046b6d470201579bf87908"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ab04aff52b0b075d8480cbbe93fb24f7a86b4308fd12a07bf23fcf949b1e282"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6c27d6a1d2c1f1fb8940cc207bafd426be411adbef5c7c15fef2d05443233e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3df40ed052e9210463d466ae860dd0ada094262f2e39e870280e4ab86a0c6f3b"
    sha256 cellar: :any,                 arm64_linux:       "b7534a45683607033ff086d2677067cb0ffa9d0081b5ebfbad801904e26d74e4"
    sha256 cellar: :any,                 x86_64_linux:      "adb1c47bc2362247ac988b98701bd178a1afb51b81bd28cd9ef67aeb6a26029e"
  end

  depends_on "rust" => :build

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  deny_network_access!

  def fetch
    rm ".cargo/config.toml"
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
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
