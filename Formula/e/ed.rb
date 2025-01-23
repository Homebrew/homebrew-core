class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.21.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.21.tar.lz"
  sha256 "60e24998727d453a5cf02c54664b97536de46a2b34cd1f4f67c1c1a61bbbad75"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "346e65c62e36ccd660d3a3e8d096208a9f8cef99034c0c5c89d0d5f446aa297b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b10cb591d03f09c8963eb95f76ffe5fd458a75d2579bd2188de2fd9637b00fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "442fde9726aeb2240258d0d1bd8a834b00159d23221094aa0bc047cbdffed950"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcfb554571f3d459814c8655a4b73f01c8803c3b838927fa2ac2114037134d2a"
    sha256 cellar: :any_skip_relocation, ventura:       "0d91abb2cb0b5ee4e90240e1c471fd7881705ba65f08e71478650023389944d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da83510be995babedcf6b48676b40c50169788bb7077ec223978c6f4fc80763"
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
