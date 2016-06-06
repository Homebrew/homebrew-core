class Nutcracker < Formula
  desc "Proxy for memcached and redis"
  homepage "https://github.com/twitter/twemproxy"
  url "https://github.com/twitter/twemproxy/archive/v0.4.1.tar.gz"
  sha256 "00c2940f91947bea9457a348316aac1aa1d4e757238aafbefc9d51057da8ede0"
  head "https://github.com/twitter/twemproxy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "276645111292739c724e136020622e688eb0c168989a917c7d1c10b1eb0040fd" => :el_capitan
    sha256 "369a87e5fc60849e8fb1b40f8df1f57406f7b86fbb7b2b5503b3b1a75fc1ecfd" => :yosemite
    sha256 "603e6a29b7f3c80680aa811e80e52ddbf5c5b35aa676d363ac79cdd254489d16" => :mavericks
    sha256 "58e30a2d345c686e6cecb492a8356d9696d9200481c55fabc7460a55ae24e162" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    pkgshare.install "conf", "notes", "scripts"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/nutcracker -V 2>&1")
  end
end
