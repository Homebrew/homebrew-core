class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/25.10.tar.gz"
  sha256 "f676b71e7dbf143291728bc0247673afb256e75917da89520795c01df1154598"
  license "GPL-2.0-only"
  head "https://github.com/processone/ejabberd.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fb03cdd8427030f04552ab27c20ae4dd4e8622507e54357e22d1db117c0afcdb"
    sha256 cellar: :any,                 arm64_sequoia: "6c2af70ef4c7beba90ad33237b2ff25b6d427e2e2cd282f5ef39a1f22d1e1a8a"
    sha256 cellar: :any,                 arm64_sonoma:  "df253b058b0d822faf3f7633f0b2329b4c8d1c6c5171aa283676fe75ea6db0b8"
    sha256 cellar: :any,                 sonoma:        "ce332373f5629441ec5d72d5e3af4442bcc5cdc0367c4fabbe003da0df89c4d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc673d4b32c832b4dd1d26d74ef115b0f8cefc4926260cae982502e1d2fe15cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "567bcd25ca021bd22afac704b2c7ad1e02fe64b7a55b065048a3d1aa8154e3c3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "erlang"
  depends_on "gd"
  depends_on "libyaml"
  depends_on "openssl@3"

  uses_from_macos "expat"

  on_linux do
    depends_on "linux-pam"
  end

  conflicts_with "couchdb", because: "both install `jiffy` lib"

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--enable-pgsql",
            "--enable-mysql",
            "--enable-odbc",
            "--enable-pam"]

    system "./autogen.sh"
    system "./configure", *args

    # Set CPP to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    system "make", "CPP=#{ENV.cc} -E"

    ENV.deparallelize
    system "make", "install"

    (etc/"ejabberd").mkpath
  end

  def post_install
    (var/"lib/ejabberd").mkpath
    (var/"spool/ejabberd").mkpath

    # Create the vm.args file, if it does not exist. Put a random cookie in it to secure the instance.
    vm_args_file = etc/"ejabberd/vm.args"
    unless vm_args_file.exist?
      require "securerandom"
      cookie = SecureRandom.hex
      vm_args_file.write <<~EOS
        -setcookie #{cookie}
      EOS
    end
  end

  def caveats
    <<~EOS
      If you face nodedown problems, concat your machine name to:
        /private/etc/hosts
      after 'localhost'.
    EOS
  end

  service do
    run [opt_sbin/"ejabberdctl", "start"]
    environment_variables HOME: var/"lib/ejabberd"
    working_dir var/"lib/ejabberd"
  end

  test do
    pid = spawn sbin/"ejabberdctl", "start"
    sleep 1
    system sbin/"ejabberdctl", "ping"
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
