class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "61ba05bc4caef9b945b047386b6a08d9fecdcf4a2b2a2a109e0e6686243b5760"
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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "4090a87b9793719c2643a2783999be75ec8a0025813e558499e0d226d3c71a7b"
    sha256 cellar: :any, arm64_sequoia: "02cec830a5e66e61ed22f22a295e72c35194883c52c1cf9a1fdbbd2cf47a7071"
    sha256 cellar: :any, arm64_sonoma:  "17aa25eee057bb063f530fe144ee0cb56e081a4084bac295b76b17b520b3f68d"
    sha256 cellar: :any, sonoma:        "767a362b5662cf2f89f7cdc7f6dde9e3c37d3d5ada43e036fca33d42d4e05ed8"
    sha256 cellar: :any, arm64_linux:   "8787425402dfe7b1fdf5c8ac7479b8a40779378e95454bad0a24e2b0ca69d963"
    sha256 cellar: :any, x86_64_linux:  "882050067883192d6bc9b97b655ac3f66406f64c5ec68cf91686e26000801324"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
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
