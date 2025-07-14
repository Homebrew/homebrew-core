class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.21.1.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.21.1.tar.lz"
  sha256 "d6d0c7192b02b0519c902a93719053e865ade5a784a3b327d93d888457b23c4b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "156989ed5661aae77cfd5d451f34ec59ff4d2e9aa81f66ffb9a04e79bf7d4c26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5021a6745f0d694cd16cc8554f82687d1f55b667147b956e6ffbe87e49998749"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "216caf7895038a6dd5f29d9e6879bc702a3dc3fac1050e96fec8a1866f5f1e50"
    sha256 cellar: :any_skip_relocation, sonoma:        "e327c4ca3773591bef39ff680193ba2169a95ae1e55ea89fdddb4ee009edd042"
    sha256 cellar: :any_skip_relocation, ventura:       "e566d7874914db40d67ae1414ac1b94bbb486f2be929c5d7e0123d296fc50fea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b3e12e402e8d6201c32d0173def749c2e74efae119318ee33cf442a79b81406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c1b571168c641627da68d30998bd1425479ca95bd311b447d960135cc032ee0"
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
