class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/22.05.tar.gz"
  sha256 "b8e93b51ae3cb650a2870fae1b6705404bb155289e97be7e9a54961a9effb959"
  license "GPL-2.0-only"
  head "https://github.com/processone/ejabberd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e4ae78568fd0c9db8eac5476082cf922e2c41d3e950cae20ba3342030ca6d2f2"
    sha256 cellar: :any,                 arm64_big_sur:  "4bf6c4c8d85610dfabea9fefbbacfedbd20ece86bdd513afbfd126b932f71630"
    sha256 cellar: :any,                 monterey:       "e36160a15fd2ace0ccca9be68f91920e366bbe7a1e76f109152ea4397123225a"
    sha256 cellar: :any,                 big_sur:        "4b3fd6069f6273d2f292d6bdec216783963e6071b0972ee11e7afd23663d1f2e"
    sha256 cellar: :any,                 catalina:       "551ed90dd256ea103807e74f7d58aa319e1bd3c34d9cf91bfb0b4d9b4492f22b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e94cd42d1f356f143e0d7ccc89cfced53138fcc2d6ce82c18044d2c9ca51b0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "erlang"
  depends_on "gd"
  depends_on "libyaml"
  depends_on "openssl@1.1"

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
    system sbin/"ejabberdctl", "ping"
  end
end
