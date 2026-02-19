class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.25.1/pgbouncer-1.25.1.tar.gz"
  sha256 "6e566ae92fe3ef7f6a1b9e26d6049f7d7ca39c40e29e7b38f6d5500ae15d8465"
  license "ISC"

  livecheck do
    url "https://www.pgbouncer.org/downloads/"
    regex(/href=.*?pgbouncer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5a3fc3c60b6965b84c3726d7a2ba38abc650ccbe07a57c96de83d9b6fd330d1"
    sha256 cellar: :any,                 arm64_sequoia: "6be837ec94647a38dd17d202a3694adf258ab90e78e5afdae17b345201dac64a"
    sha256 cellar: :any,                 arm64_sonoma:  "b90669ff9c33f12172c202a805aad612aff2c0c29d3085165c5bb7b42750922f"
    sha256 cellar: :any,                 sonoma:        "ca92fc4e84e84654b20e3696eedf19fc5ef394cae7ce74ffe111a43317eb90e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a4786998a1c81f0a7f5080626e4133800cc8f013431e9c3e350040c15db6f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f8526ad5bf46f76b9b8821dd240a512452a1502020dee3ad3d0c1a7c5f99e11"
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
