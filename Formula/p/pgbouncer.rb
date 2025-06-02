class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.24.1/pgbouncer-1.24.1.tar.gz"
  sha256 "da72a3aba13072876d055a3e58dd4aba4a5de4ed6148e73033185245598fd3e0"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c520e5665bb21b6ab7d77518d49d1b2979f631fd87bd8e3f9c262bb350916048"
    sha256 cellar: :any,                 arm64_sonoma:  "8d48d6942ec879fa455056cc92fc75a090bae0e0acab0aa101139891bbd6a6ce"
    sha256 cellar: :any,                 arm64_ventura: "7de7551aac5f589fb691bcc55f4bae5ebbb68da3434751fe1be14203a6186aa2"
    sha256 cellar: :any,                 sonoma:        "75a3afc5fac5c466ab0e103a8844f09d78c5347127bd90769d240a72b6383554"
    sha256 cellar: :any,                 ventura:       "680d9567e322ca0a079bd281aa54e442cec5f61b2014cd48f5b41c3e5f541c13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9fe8b6575f317bd25b10f302ea651246a0a5b986998a6a4e33a34f771be992b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d06c2e9d58c439b5c19d7a402b66c76d3434ff8a7d44a8e4fd390057e7bd430"
  end

  head do
    url "https://github.com/pgbouncer/pgbouncer.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pandoc" => :build
  end

  depends_on "pkgconf" => :build
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
