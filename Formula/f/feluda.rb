class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "c66576852092def1c1fa8161a3fab53a59c6e1ae8242958e6e208bed132c493d"
  license "MIT"
  head "https://github.com/anistark/feluda.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dbe15da30f855a8551317ee53a07674b706ae3f2fb3897c378798d453b66c05c"
    sha256 cellar: :any, arm64_tahoe:       "d1905151681b909e3d60d720e93fced95036ed852aae4b91b50e7b73b5052048"
    sha256 cellar: :any, arm64_sequoia:     "0a90d3b7fa0842ad9635cc709f2d2fe0504b578ca4e35b5f50b04b2eaa967b51"
    sha256 cellar: :any, arm64_linux:       "6e1e2ec5a3f299a49cbf046c3323a766198e30803a81c1656899b5a941e3198e"
    sha256 cellar: :any, x86_64_linux:      "c9e2ae4cd44845bbada15f67625e0b2c43b2da318ff2405a6e3c18462bea604a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match "❌ No supported project files found.", output
  end
end
