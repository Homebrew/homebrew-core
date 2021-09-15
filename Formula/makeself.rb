class Makeself < Formula
  desc "Generates a self-extracting compressed tar archive"
  homepage "https://makeself.io/"
  url "https://github.com/megastep/makeself/archive/release-2.4.5.tar.gz"
  sha256 "91deafdbfddf130abe67d7546f0c50be6af6711bb1c351b768043bd527bd6e45"
  license "GPL-2.0-or-later"
  head "https://github.com/megastep/makeself.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f4662b6da2d3d6494554dabb44e7a21d13273a1283075689bf13d5056517b3c2"
  end

  def install
    # Replace `/usr/local` references to make bottles uniform
    inreplace ["makeself-header.sh", "makeself.sh"], "/usr/local", HOMEBREW_PREFIX
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
    (source/"script.sh").write <<~EOS
      #!/bin/sh
      echo 'Hello Homebrew!'
    EOS
    chmod 0755, source/"script.sh"
    system bin/"makeself", source, "testfile.run", "'A test file'", "./script.sh"
    assert_match "Hello Homebrew!", shell_output("./testfile.run --target output")
    assert_equal (source/"foo").read, (testpath/"output/foo").read
  end
end
