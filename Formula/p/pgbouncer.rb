class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.23.1/pgbouncer-1.23.1.tar.gz"
  sha256 "1963b497231d9a560a62d266e4a2eae6881ab401853d93e5d292c3740eec5084"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c24c8c4e07821b2bc9aff0c8ee6fe37f84f39b7ce6b3c5c0af84826e67091a77"
    sha256 cellar: :any,                 arm64_sonoma:   "054274d58e1129965296edcb1867b22829c2bc9a5a8d40c855817a262a0278f0"
    sha256 cellar: :any,                 arm64_ventura:  "07895230a7f4541ef17ed81c0ca645e66fa6a5a33ea9649bbc3de5339c02ec0b"
    sha256 cellar: :any,                 arm64_monterey: "742bc9d8abb46d62003003543a79e6b25b34d5bbb036d72cbc51ac01680e1e41"
    sha256 cellar: :any,                 sonoma:         "6478a0ce1e3651c8043c3ef6cda60a1aafa0c93128b26e4b99dbc41b7d04928e"
    sha256 cellar: :any,                 ventura:        "e5f91830338d0a52d66db8d287163f303c09d00d2d71304b7f9a37a25b283841"
    sha256 cellar: :any,                 monterey:       "933cae41059f7198a05d9c73af6f7f522be5af0ac8f7e50797b028e42dd095f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5509640fed151b1d1378d8ce25ce4f054e4af9bea5522028897537490365217b"
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
