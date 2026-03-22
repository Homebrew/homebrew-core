class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/26.02.tar.gz"
  sha256 "676feea9ee8aeb3c1bc3c1844308a783941548d9befc3b252cd1ff0b7532842f"
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
    sha256 cellar: :any,                 arm64_tahoe:   "d36ff4816c0888a12396d6d190abfbc8cde13ffbe35ca5465deefd5d54a1d1b2"
    sha256 cellar: :any,                 arm64_sequoia: "989ccf6f8062daab2f2a2567e803e26fd574cc23dbe306f716b042057f9627ef"
    sha256 cellar: :any,                 arm64_sonoma:  "ba6b3be9f974635f7abde2dca78bb4104e58c654fcedbd14a8eac5154177e4c4"
    sha256 cellar: :any,                 sonoma:        "c9d81c546e568d4f9cfc4bb4fa31dd6370de5bc6fdfc9b2139380f77b9cebf69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c59a6280e58d3113b8d251402ebfe8b2c981e72eb2c329385c4a8442f2b04482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7f145f5f49e92586079a8ecc7d6d8aef62d8942459a2f9d4925e1057f8493bd"
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
