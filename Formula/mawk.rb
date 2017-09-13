class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "ftp://ftp.invisible-island.net/pub/mawk/mawk-1.3.4-20161120.tgz"
  sha256 "361ec1bb4968c1f1f3b91b77493cf11b31c73ff8516f95db30e4dc28de180c1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "52d61963ba6494674cdea5d3fd95e9551b8277b9bc5e189f93b1126d5ae3dd27" => :sierra
    sha256 "d39e71dfe41cdf2e480a5858938918509e2a00e6b5dcb181d14fc5cdedd91b24" => :el_capitan
    sha256 "8ef45e294dbab1b4c4615861b6eee4fdd179649072fe41eb554e6bc93f2f5a42" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = shell_output("#{bin}/mawk -W version 2>&1 | #{bin}/mawk '#{mawk_expr}'")
    assert_equal version.to_s, ver_out
  end
end
