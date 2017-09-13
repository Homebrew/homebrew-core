class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.14.2.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.14.2.tar.lz"
  sha256 "f57962ba930d70d02fc71d6be5c5f2346b16992a455ab9c43be7061dec9810db"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bcab4bf26dae3b57ffe1097744191315941b6e26c6a43157e2595bb64f40c17" => :sierra
    sha256 "b891b87205fbfcc593673726193ceb44535155237d09dc17b38359ed5abee125" => :el_capitan
    sha256 "d8d925d35a5e3a08353960f029423b4f6e7427b2ecc916407ae7e541b0ba3cfa" => :yosemite
  end

  deprecated_option "default-names" => "with-default-names"
  option "with-default-names", "Don't prepend 'g' to the binaries"

  def install
    ENV.deparallelize

    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    if build.without? "default-names" then <<-EOS.undent
      The command has been installed with the prefix "g".
      If you do not want the prefix, reinstall using the "with-default-names" option.
      EOS
    end
  end

  test do
    testfile = testpath/"test"
    testfile.write "Hello world\n"
    cmd = build.with?("default-names") ? "ed" : "ged"
    pipe_output("#{bin}/#{cmd} -s #{testfile}", ",s/o//\nw\n", 0)
    assert_equal "Hell world\n", testfile.read
  end
end
