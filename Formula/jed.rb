class Jed < Formula
  desc "Powerful editor for programmers"
  homepage "https://www.jedsoft.org/jed/"
  url "https://www.jedsoft.org/releases/jed/jed-0.99-19.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/j/jed/jed_0.99.19.orig.tar.gz"
  sha256 "5eed5fede7a95f18b33b7b32cb71be9d509c6babc1483dd5c58b1a169f2bdf52"

  bottle do
    rebuild 1
    sha256 "74df74658f783e6de97ed841b1e2532ead3681c7816d55c52e56d4d5056050b9" => :mojave
    sha256 "b8e8f13a1936067960fd2040019d30fc3cedabba4f5c3c22712990f64e09c752" => :high_sierra
    sha256 "caa1269eeac2bd84b2287426c77d501956632f01f92c44605bf8b5d76ab7550a" => :sierra
  end

  head do
    url "git://git.jedsoft.org/git/jed.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "s-lang"

  def install
    if build.head?
      cd "autoconf" do
        system "make"
      end
    end
    system "./configure", "--prefix=#{prefix}",
                          "--with-slang=#{Formula["s-lang"].opt_prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.sl").write "flush (\"Hello, world!\");"
    assert_equal "Hello, world!",
                 shell_output("#{bin}/jed -script test.sl").chomp
  end
end
