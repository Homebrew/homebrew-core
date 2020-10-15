class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.8",
      revision: "cfcb2e4577fe00e744d5684c0871fd8ce849930c"
  license "MIT"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdc49d5bc540b16e9165eadb793fcf755a4342f1b53fb9df9d5859b51a8335c9" => :catalina
    sha256 "16194e8139cf062a789f767e4d9e572a31b5438c7abf36ee2615093de956d5a8" => :mojave
    sha256 "5ddc2cdc29a432a2515950946076ebb1ddf7dba410019fd77790f3ba5a2d874c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build-tags"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
