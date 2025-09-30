class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftpmirror.gnu.org/gnu/ed/ed-1.22.2.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ed/ed-1.22.2.tar.lz"
  sha256 "f58d15242056e15af76f13f34c60d890fa2a2d5cb0abef91c115e4d83794ffe3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "129a3faf785763ea02982b84807183dbdd6bae468486d1595b7c444ce977f96d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a6d98b2ab8a34ef2f1031ffb0bd5c97b47d077c5054c832d6d2276052711014"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69d3440c42e8722d0bf705773cc2b6429870d95da50a06c6aa2b2db98e514ada"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02be970d623516f89b3f9e8590351fe567157b69e8d3e7785c56f3ea20c886f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bef0ed95e60d407fb17bb80132ed016a0fd74dc3b440a07877cb001289f1176"
    sha256 cellar: :any_skip_relocation, ventura:       "9ce25e1467cac30b8d58db9d938e64b167482b4668750ad43c5fcf43bfd428e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb644565398a20f52f8536bd1936e36fbf5291a2e643bce7ac17a39af05881b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e07b4f0ecebc8ddd4f64f84682b9a3a14b6235801a223d8d3dbaee2c524070b4"
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
