class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "0577e3b0cabc95abd37e23b92236a52a4e21920da0a5eca1a2bc43ef087116dc"
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
    sha256 cellar: :any,                 arm64_tahoe:   "5b961c4c5a6e6a250e69869dd660fcd8ad68ad62ea64c8b8e9bd9ceafedbf159"
    sha256 cellar: :any,                 arm64_sequoia: "dec3ea78d21d98c168b11b25ffe291662e2a71665d2ba3d6573ba99e42df4544"
    sha256 cellar: :any,                 arm64_sonoma:  "22983adfb38c1e7f0ef4cb963d8f8a05b2a4e95226d954caf0e0770be152586b"
    sha256 cellar: :any,                 sonoma:        "635a6ea9058992607d6ec5dca2af35846367fe6bc34ae72479e2618a26933c07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "262691d6645d9ccfcd2ebbd1d658ba05cd56384f4c26c9ca0747d1480e7205b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd02e1dfe0f15ddce00b2ae2da60587488da7a75836883f40b5a9876bd3cc797"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match "❌ No supported project files found.", output
  end
end
