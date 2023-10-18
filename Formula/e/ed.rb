class Ed < Formula
  desc "Classic UNIX line editor"
  homepage "https://www.gnu.org/software/ed/ed.html"
  url "https://ftp.gnu.org/gnu/ed/ed-1.19.tar.lz"
  mirror "https://ftpmirror.gnu.org/ed/ed-1.19.tar.lz"
  sha256 "ce2f2e5c424790aa96d09dacb93d9bbfdc0b7eb6249c9cb7538452e8ec77cd48"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10deebcbd045ed573ce2e7af867525c217ac609e388ab5846be864353b6e34dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d84c3db0a600dc50bd4fa5344a15cb7760ec1e72b9ac436e9cce7cf6296eeeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa2e563bdbebedbbe3e925d8e69f931541e15b8665ecfcadfdbb5de5f321db2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69753a6cd7fc3764d67976f4687c33ea8c682710bdf2e40a6b60e85a47900958"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdaeada6f2789d229236b63a8455d818c41e82bad27b5d3e0faf0e137ba07fa6"
    sha256 cellar: :any_skip_relocation, ventura:        "d187dae7f0f051072f6b83d3882acb93cfeda90f152b084d7658e96f4a2503cd"
    sha256 cellar: :any_skip_relocation, monterey:       "de41723a0dcc7a723634c32c6e37acf375b895cbc47f6eff165e2605c3359dca"
    sha256 cellar: :any_skip_relocation, big_sur:        "35e506177b499ea82a72317bae1be90b5fdaac7449dc46ecdf2589d96a8c939c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7dd5e50aebd4e438043cbce5628b46cd35f5d82b4be56241c3d813c7f7d6c94"
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
