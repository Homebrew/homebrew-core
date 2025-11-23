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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f6989df36eaff7f94899191b401b7aa476302e48d2bc678b93a5c6fe4f072d96"
    sha256 cellar: :any,                 arm64_sequoia: "f950e41b7d5be16bd933f19d3fda274bfd2575c6175162d3439a239c658e5a8c"
    sha256 cellar: :any,                 arm64_sonoma:  "dbc57126f313169f5ce5e43afe231fbb44f51f2ee744d962a314563907bdc608"
    sha256 cellar: :any,                 sonoma:        "2b9a87d20a4ae91a6b067bb5ab3334bda856824e203bc5d9b51a968d07e71c5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f89e7c92d42cadb80a7d6c75f007b01b375f075752de0acbf9733ca597ed16a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25535e79314642f393ce2c26787362263f0466e11df8b63f8a40713dde85a877"
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
