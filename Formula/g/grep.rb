class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.11.tar.xz"
  sha256 "1db2aedde89d0dea42b16d9528f894c8d15dae4e190b59aecc78f5a951276eab"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "b2b59b800b2017f64aa518d30dd83bb009486b67bab2b9fd2f5b96383741ccf3"
    sha256 cellar: :any,                 arm64_sonoma:   "bad191c3178de90cfea096ef75c4ae8c97a3fed1aa36a9fd0eb88e02e0300ecd"
    sha256 cellar: :any,                 arm64_ventura:  "3b671635a7a98ec6a5fd2f1ed1f7b61274fe68aa5ba2e23c448241777e5c23e0"
    sha256 cellar: :any,                 arm64_monterey: "f4b2ed835aac8ced4b617609f502c657ea1f20a97282e1c19aa75b08316bd952"
    sha256 cellar: :any,                 sonoma:         "ce3337c484b58a52ffc841fae13f3f530fbe8132a53f7f8a3fae8e17a994fa6c"
    sha256 cellar: :any,                 ventura:        "0499226ca301f19321f44d9e0229f5dffceea6af6509835af86c073ac3a3e329"
    sha256 cellar: :any,                 monterey:       "85f180f4b3c3563befd80d4d91389a9a7e4e69eb956c74251a3d3ed83fa26cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8a180d77300df9dfad5d2e12b7f2061207fef15b63a6a4ed6d4082daa00345d"
  end

  head do
    url "https://git.savannah.gnu.org/git/grep.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "texinfo" => :build
    depends_on "wget" => :build

    uses_from_macos "gperf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "pcre2"

  def install
    system "./bootstrap" if build.head?

    args = %W[
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --with-packager=Homebrew
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make"
    system "make", "install"

    if OS.mac?
      bin.children.each do |file|
        (libexec/"gnubin").install_symlink file => file.basename.to_s.delete_prefix("g")
      end
      man1.children.each do |file|
        (libexec/"gnuman/man1").install_symlink file => file.basename.to_s.delete_prefix("g")
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
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"

    if OS.mac?
      grepped = shell_output("#{bin}/ggrep -P match #{text_file}")
      assert_match "should be matched", grepped

      grepped = shell_output("#{opt_libexec}/gnubin/grep -P match #{text_file}")
    else
      grepped = shell_output("#{bin}/grep -P match #{text_file}")
    end
    assert_match "should be matched", grepped
  end
end
