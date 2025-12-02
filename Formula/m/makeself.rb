class Makeself < Formula
  desc "Generates a self-extracting compressed tar archive"
  homepage "https://makeself.io/"
  url "https://github.com/megastep/makeself/archive/refs/tags/release-2.6.0.tar.gz"
  sha256 "3af5218dfb80d20a156d3c50fa0d510c7b244d9676813659f8d220bc95405f07"
  license "GPL-2.0-or-later"
  head "https://github.com/megastep/makeself.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da1702d89713395dd58527ae74a8489f278527c9bfc5eb04d30e6e74dc306032"
  end

  def install
    libexec.install "makeself-header.sh"
    # install makeself-header.sh to libexec so change its location in makeself.sh
    inreplace "makeself.sh", '`dirname "$0"`', libexec
    bin.install "makeself.sh" => "makeself"
    man1.install "makeself.1"
  end

  test do
    source = testpath/"source"
    source.mkdir
    (source/"foo").write "bar"
    (source/"script.sh").write <<~SH
      #!/bin/sh
      echo 'Hello Homebrew!'
    SH
    chmod 0755, source/"script.sh"
    system bin/"makeself", source, "testfile.run", "'A test file'", "./script.sh"
    assert_match "Hello Homebrew!", shell_output("./testfile.run --target output")
    assert_equal (source/"foo").read, (testpath/"output/foo").read
  end
end
