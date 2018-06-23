class Hh < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/1.25.tar.gz"
  sha256 "9d50e46d2eefc667f4d2b9cd41856be6ffb33a897ab1b036886573d61cadb27f"
  head "https://github.com/dvorka/hstr.git"

  bottle do
    cellar :any
    sha256 "b5bef6ba56d49837f25b4e99b15065b6658fc3ff9c230bd8136c60b3528c9d48" => :high_sierra
    sha256 "4c6295eb6610a8b304d576dc8d1fec1fe70d98f267afdbd5e95f3dc40354f155" => :sierra
    sha256 "e8b147fea236a8f50fe8b63e83050d3060348ebca7fb53ed08d592d85675e41f" => :el_capitan
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
