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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0820537ced409e826ae4b0aadb194aec0e0eed682234748ef154d58a5d322611"
    sha256 cellar: :any,                 arm64_sequoia: "07a1787155e1e0b2b61f58a800ea98318352fcc38ed63f35d298d08414d1b647"
    sha256 cellar: :any,                 arm64_sonoma:  "1db4a5c656e9f73aad5f92b8e40dd0db0032f8a3a578363135a74c01efd6d0b8"
    sha256 cellar: :any,                 sonoma:        "8277715921e6a22e508224ce860251266792aae0e6f6da8d235a9f35db9b2c48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38855ce0cba970ef8ac1ddd63d30a7927600a062e9a536669d082bdc31ce0725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66312f043670fcab793d62d6fdf753095cb660a829c0744f5790ce493d960917"
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
    ENV["EJABBERD_BYPASS_WARNINGS"] = "true"
    ENV["EJABBERD_CONFIG_PATH"] = testpath/"ejabberd.yml"

    cp etc/"ejabberd/ejabberd.yml", testpath/"ejabberd.yml"
    inreplace testpath/"ejabberd.yml", "port: 1883", "port: #{free_port}"

    pid = spawn sbin/"ejabberdctl", "foreground"
    sleep 1
    system sbin/"ejabberdctl", "ping"
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
