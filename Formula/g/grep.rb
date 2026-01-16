class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftpmirror.gnu.org/gnu/grep/grep-3.12.tar.xz"
  mirror "https://ftp.gnu.org/gnu/grep/grep-3.12.tar.xz"
  sha256 "2649b27c0e90e632eadcd757be06c6e9a4f48d941de51e7c0f83ff76408a07b9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1455dc9ac997c60bfe18c1f147c1fc9f72e7c5096ff59a2c41cd97f0ca99936"
    sha256 cellar: :any,                 arm64_sequoia: "cb3715e0ab1d3d667c577b6823d444ade6ea5ca2f6bf82a30daf072bdb8f0f3a"
    sha256 cellar: :any,                 arm64_sonoma:  "195169d334c119c284407191a0a3b55b008d16ba59c4046391b7f5c4b747b2ed"
    sha256 cellar: :any,                 arm64_ventura: "3bca0cd49cefeac06e5656a349069e8435fd07e3f3c97f04c1351d48bbc44e4d"
    sha256 cellar: :any,                 sonoma:        "742da3d1e04f240f7dc0de96eb1a9d309a36e238af851adc1623d1482c1f6699"
    sha256 cellar: :any,                 ventura:       "92d27595ccca0054a7995282b20d004dfa41e8f11a28cfac18f9f4b80e26ec9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c15cf4f4a7a9f24466a59e6b0deb5cc785015adac16f87777ac346a333f0c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c50dff022ebab698c92d9accf3534d6e38ae5d5920ffcd172fa1bfbb9017c71"
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

  depends_on "pkgconf" => :build
  depends_on "pcre2"

  def install
    system "./bootstrap" if build.head?

    args = %W[
      --disable-nls
      --infodir=#{info}
      --mandir=#{man}
      --with-packager=Homebrew
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args, *std_configure_args
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
