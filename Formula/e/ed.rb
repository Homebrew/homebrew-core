class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftpmirror.gnu.org/gnu/ed/ed-1.22.4.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ed/ed-1.22.4.tar.lz"
  sha256 "987a1ebbbad3fcf63a1ffa9e29b3fa7de065150d16319d0a49dd8b57f81d3e9c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7301dedf05cb4d52d9352f87bced521de400927c799ae33732354308dcd2a9cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53cc514ddf510a9dabbe2f292fbcd5b000fbf5bce0ff8130829f0b88f3a11b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4768f01b90e87fbcca70e55b8d61473d5e286ede6659cddbf4214b239c18e10"
    sha256 cellar: :any_skip_relocation, sonoma:        "be238e3fbda612bfe5be63ad31081e1dea9f88f9518676c1c36f59ad1f602dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f492b80af2c7dbf788c0013c023d1fc80f7c26280401df85478328c7ec1d709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40dd6001c55848d6c4b0734482fb6a1534b1403eabd24bc9b3c5fb9746f05510"
  end

  keg_only :provided_by_macos

  def install
    ENV.deparallelize

    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" if OS.mac?

    system "./configure", *args
    system "make"
    system "make", "install"

    if OS.mac?
      %w[ed red].each do |prog|
        (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
        (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
      end
    end

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    testfile = testpath/"test"
    testfile.write "Hello world\n"

    if OS.mac?
      pipe_output("#{bin}/ged -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read

      pipe_output("#{opt_libexec}/gnubin/ed -s #{testfile}", ",s/l//g\nw\n", 0)
      assert_equal "He word\n", testfile.read
    else
      pipe_output("#{bin}/ed -s #{testfile}", ",s/o//\nw\n", 0)
      assert_equal "Hell world\n", testfile.read
    end
  end
end
