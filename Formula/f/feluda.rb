class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "cb512ea32a3973b17a86e5c4c88bf5ba70f8e6cddda6a697172522e87b691070"
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
    sha256 cellar: :any,                 arm64_tahoe:   "10ed5292af87e91eb0874142c85841e69518d4b5bf90d77031a899992ac35072"
    sha256 cellar: :any,                 arm64_sequoia: "94bdf34ff65f8b0729bc533839876b888e287ee121e49d3d706738b1ddf4c81c"
    sha256 cellar: :any,                 arm64_sonoma:  "7ba6a06c3ae47361be31f9c00abe977cf0198985473668406d72283a95fc4e5f"
    sha256 cellar: :any,                 arm64_ventura: "6973d87e5817d663db874179c06c3f2965d752e3c4f915d5f1299d662499ea86"
    sha256 cellar: :any,                 sonoma:        "592339e97cd43fa5ea7e02f30ad0d4a3f1023d3d8c1c59ea7e49bd2b673473b5"
    sha256 cellar: :any,                 ventura:       "ce60131895977c5270c8ab7bc7d4d287efb1491950c18f0694584334d8dcb1d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0a82398a8608dada7c9f969b9826918a4635c102b69559a8af7565f727f0261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aba35c9012b54a43554ae933fb5c7eb31a6328e5e55beb4f0b79e9084cd57753"
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
