class Hh < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/1.22.tar.gz"
  sha256 "c4995e7041dc66e2118f83bd4c6c7f4cff5b4c493ca28bd7e4aef76edeff71ba"
  head "https://github.com/dvorka/hstr.git"

  bottle do
    cellar :any
    sha256 "39cbce5e5288725d6fbf686163e5609fe41eaf212565481ec53836cab87d0610" => :sierra
    sha256 "f1ea86ec9b53d0de43a3880e0db700584e272e8e3ff9c5e552e2c11d48c47b7e" => :el_capitan
    sha256 "c9223089815736888069cb8bb168a8dfe1332bae8e2293b0736ad74772ec589b" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["HISTFILE"] = testpath/".hh_test"
    (testpath/".hh_test").write("test\n")
    assert_equal "test", shell_output("#{bin}/hh -n").chomp
  end
end
