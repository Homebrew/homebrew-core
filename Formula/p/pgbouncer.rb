class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.22.0/pgbouncer-1.22.0.tar.gz"
  sha256 "c6ee37a8d7ddbebbf8442d8f08ec07c3da46afb2aae3967388c1481698a77858"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5a0a1620473f824d7c6afff7fce0cd25ab980979d30a2a4fc70a2c972777d473"
    sha256 cellar: :any,                 arm64_ventura:  "ee7d2b110b691508f9bc40552a71b06c5f8ab3078674042a734fe715c6962f42"
    sha256 cellar: :any,                 arm64_monterey: "50fe7352dbcd0021e4697d3be863eafef31546653170731a85d4b07460543707"
    sha256 cellar: :any,                 sonoma:         "a5382c115450c0cbaf8c13173bb1cd9870e12adab480541c7df0e061d49d8210"
    sha256 cellar: :any,                 ventura:        "758b8e222e90fcca15ad0fc53a3743d6f2844e6ddec12983c3643d8180d22836"
    sha256 cellar: :any,                 monterey:       "71c84ae43275f92fa75a6cf69963971001fe3adb174189ec0168ba9cb8145a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f5e4404f05547c09022aedc07a7c5774e78cc1593c53f7f41323ce201fcbff"
  end

  head do
    url "https://github.com/pgbouncer/pgbouncer.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pandoc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
    bin.install "etc/mkauth.py"
    inreplace "etc/pgbouncer.ini" do |s|
      s.gsub!(/logfile = .*/, "logfile = #{var}/log/pgbouncer.log")
      s.gsub!(/pidfile = .*/, "pidfile = #{var}/run/pgbouncer.pid")
      s.gsub!(/auth_file = .*/, "auth_file = #{etc}/userlist.txt")
    end
    etc.install %w[etc/pgbouncer.ini etc/userlist.txt]
  end

  def post_install
    (var/"log").mkpath
    (var/"run").mkpath
  end

  def caveats
    <<~EOS
      The config file: #{etc}/pgbouncer.ini is in the "ini" format and you
      will need to edit it for your particular setup. See:
      https://pgbouncer.github.io/config.html

      The auth_file option should point to the #{etc}/userlist.txt file which
      can be populated by the #{bin}/mkauth.py script.
    EOS
  end

  service do
    run [opt_bin/"pgbouncer", "-q", etc/"pgbouncer.ini"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgbouncer -V")
  end
end
