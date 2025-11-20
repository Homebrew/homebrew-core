class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.25.0/pgbouncer-1.25.0.tar.gz"
  sha256 "290bad449e4580f0174d3677c26c1076d4ce5dd7ca116ae1fca10272ef74d10e"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8771d1f42fe4d13edf36d0d3ecc82bc5d51a52369e937400499f7d7543437ab"
    sha256 cellar: :any,                 arm64_sequoia: "1b99d9e9c8fe21c63b49bb6e9f3cd5927cf217f8a8369817a76e7140fd5673c3"
    sha256 cellar: :any,                 arm64_sonoma:  "44331407e6f47922ded1f95e89fa5a4a6da9cdbf0a38bb18834844f7767dd516"
    sha256 cellar: :any,                 sonoma:        "2f72d075f19614ac187bca2a3155fce26277e5e0bf5a4044da7ecc2bf900bea8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9150f758137c77a7d823532ef2e5ae7665d26069c461723a8d7119b3f40555dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bcf8b5317f58b7780b5a7613ce0c55d22c2603c8393dde37061beec4da3d91f"
  end

  head do
    url "https://github.com/pgbouncer/pgbouncer.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  uses_from_macos "python" => :build

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
