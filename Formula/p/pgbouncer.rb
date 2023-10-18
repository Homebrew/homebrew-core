class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.21.0/pgbouncer-1.21.0.tar.gz"
  sha256 "7e1dd620c8d85a8490aff25061d5055d7aef9cf3e8bfe2d9e7719b8ee59114e2"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "076e03afc8eace2ebfb562c197df266eda72e172d2a33d7e621036a76efc17e5"
    sha256 cellar: :any,                 arm64_ventura:  "a5db94d3867c1673d9e334eafe7e6ed8d34da22cccccb606c4474c420121f79c"
    sha256 cellar: :any,                 arm64_monterey: "9e1983a48cbcca8c5de0aa76730e63e674f9b71ea7bc9a143b5403a5a9e30960"
    sha256 cellar: :any,                 sonoma:         "0951edd0a415af4f1f8d4c75cfeff0f355cee7e5ebc8c7c918a4e59420d71ccf"
    sha256 cellar: :any,                 ventura:        "a1a95e78076cdb7ce78c473fa09d3c8e5c4edba64733fd6a01a0c03dc2dbd87d"
    sha256 cellar: :any,                 monterey:       "cd1807941b51ff7c60a2186807986c42b0b1c567474c914f710485e2e15bd5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d16f7fe29f2b9c33dafb4375beac9d78bf166463fae344d8e91d3b2e7ddb7b1d"
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
