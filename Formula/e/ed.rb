class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.20.2.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.20.2.tar.lz"
  sha256 "65fec7318f48c2ca17f334ac0f4703defe62037bb13cc23920de077b5fa24523"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2212d012a399dc0bad58e1685eb8ddd5d1878300ffc1c5ae0d5fceb00b501ec6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5e2085684e3c92fbfd33c36230d0948bf13fce8d79664894213f514dee00811"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06825e7936586efb4577e2f00f07763e0e126e3415b3cd83b57af05e5695889e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b57aba94d5a86dedfef793b7f035c20449d7441b4c2c5c96c8f591181830c79"
    sha256 cellar: :any_skip_relocation, sonoma:         "738c04bc4f1d593dd2b24c4729ef586d66f5b33bb53085c431798d4b065ecefa"
    sha256 cellar: :any_skip_relocation, ventura:        "a0dcf2f47ca608af30f5ba70fd1c7c0344a728fcdb4812d2a284a4393ac87728"
    sha256 cellar: :any_skip_relocation, monterey:       "abcf20b00afa925f070a7840b44b01e57a02fd5ccd06632061863f50103a5c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "190b7d16443a9415e21a0ee9d93a106d7890680c428f6bfa1a23f0b7d994c67d"
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
