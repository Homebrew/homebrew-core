class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.1.tar.xz"
  sha256 "db625c7ab3bb3ee757b3926a5cfa8d9e1c3991ad24707a83dde8a5ef2bf7a07e"

  bottle do
    cellar :any
    sha256 "d55c4d626559f62538f07f9a7fd5c29ab951e65f3f2f83159cbc141d8f1c9649" => :sierra
    sha256 "b2af64e183559b020fe2f744979af82ad073611f47998e2073aac855d92aaf1a" => :el_capitan
    sha256 "d6e3213787d5da9acd33277ab8b2de5c1268082c39be0c7668ab601f55b47037" => :yosemite
  end

  option "with-default-names", "Do not prepend 'g' to the binary"
  deprecated_option "default-names" => "with-default-names"

  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --with-packager=Homebrew
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    if build.without? "default-names" then <<-EOS.undent
      The command has been installed with the prefix "g".
      If you do not want the prefix, install using the "with-default-names"
      option.
      EOS
    end
  end

  test do
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"
    cmd = build.with?("default-names") ? "grep" : "ggrep"
    grepped = shell_output("#{bin}/#{cmd} match #{text_file}")
    assert_match "should be matched", grepped
  end
end
