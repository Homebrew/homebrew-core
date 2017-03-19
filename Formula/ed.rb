class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftpmirror.gnu.org/ed/ed-1.14.2.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ed/ed-1.14.2.tar.lz"
  sha256 "f57962ba930d70d02fc71d6be5c5f2346b16992a455ab9c43be7061dec9810db"

  bottle do
    cellar :any_skip_relocation
    sha256 "405f2bad74df5b2b414b3dcea1ab59b449249de212bd806efde9feafa16d9fe9" => :sierra
    sha256 "7b76873e8861fbd506841e6bc86b84fd9880a3840d8d42bd2f97aa173602e53c" => :el_capitan
    sha256 "4e57f31ea84c073844cb75dc46bbaead3f46a84b238ad0d5f8240766fba1040e" => :yosemite
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
