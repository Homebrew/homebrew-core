class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.20.1.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.20.1.tar.lz"
  sha256 "b1a463b297a141f9876c4b1fcd01477f645cded92168090e9a35db2af4babbca"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45c331f78a3aefad442b6934a68474bb955a2e29404282429eb22cd196603fed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68e083d77f4e2e853e62634f6b56c23e0b5874dbc60b9817afa16167526a0947"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02ad1d8d11449d9a3402bfeeade360e82aa26bb9f3b21db598ae16a7e96002b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "80fd9be91e7efa09106389bb0ad4ec5da75658733cd80bad57d8c77174e613a5"
    sha256 cellar: :any_skip_relocation, ventura:        "6aa6e587ee8c30ba97aca150a0ded127bf11ac6ed615c56394fb6362658e3bbd"
    sha256 cellar: :any_skip_relocation, monterey:       "8b424b0d4cabe42aa8bc81d53081607ff7333919ba410e501a61ad130e5946c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "926e1785422f3a7012cb5c399ae7062f64822476fccc47514225168a38239530"
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

    libexec.install_symlink "gnuman" => "man"
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
