class Ohcount < Formula
  desc "Source code line counter"
  homepage "https://github.com/blackducksw/ohcount"
  url "https://github.com/blackducksw/ohcount/archive/v3.1.0.tar.gz"
  sha256 "1b7bef72ea5d75c99ea46d219f2d7350b716738fb07dda31e2099a8e0c00e329"
  head "https://github.com/blackducksw/ohcount.git"

  bottle do
    cellar :any
    sha256 "20a3923fd7c0ad7cd9474c72b9ce9045ec396b2d0ff6cdb02c559bd2a70dc33b" => :high_sierra
    sha256 "b3d4be11858ec755a35d97259c145a76d64ee2e3c0e776cc81578a323b549399" => :sierra
    sha256 "4c6ca73681e204052237392b9c931e46fcdd599c6605bfc7861e3e91dce9ceac" => :el_capitan
    sha256 "08d9df78da1afb3654e96fa142db9eb1981dbbc14861db522dae6e8cc08791e4" => :yosemite
    sha256 "055b2eb9460b1723bcb8a0f215ddda35750ce6d9b9c3cd0bce75d4e9584f0b62" => :mavericks
  end

  depends_on "libmagic"
  depends_on "pcre"
  depends_on "ragel"

  def install
    system "./build", "ohcount"
    bin.install "bin/ohcount"
  end

  test do
    (testpath/"test.rb").write <<~EOS
      # comment
      puts
      puts
    EOS
    stats = shell_output("#{bin}/ohcount -i test.rb").lines.last
    assert_equal ["ruby", "2", "1", "33.3%"], stats.split[0..3]
  end
end
