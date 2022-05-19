class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/22.05.tar.gz"
  sha256 "b8e93b51ae3cb650a2870fae1b6705404bb155289e97be7e9a54961a9effb959"
  license "GPL-2.0-only"
  head "https://github.com/processone/ejabberd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c4873e5f20dc834c2b31e8a3a0a8e4b2c72ff0cc3f1af5de65236cf2823d6524"
    sha256 cellar: :any,                 arm64_big_sur:  "2c0f3a0d99e52c4e25e6844669929f992ee89514847532aa0cfff77aba2b1297"
    sha256 cellar: :any,                 monterey:       "2aab8f179a30fb248fd1e07a00ac149bd763451f11a385f916d1950e0dea5858"
    sha256 cellar: :any,                 big_sur:        "38f754a3aa6ef9c634104f39fd0c41e5d501525d69b437fd1520ff5544c1d01e"
    sha256 cellar: :any,                 catalina:       "383e3974b71e4d572c5f509b3b33f228eef34f18ab607633e632c387a9562863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e4ae90bc4c22ec6114b3a26a9cb9d2285328b4e86219e58d50dae56cba2aec"
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
