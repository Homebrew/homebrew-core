class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://static.process-one.net/ejabberd/downloads/21.12/ejabberd-21.12.tgz"
  sha256 "b6e6739947d3678525b14ee280cedb1a04280c83ea17a4741795aac99fbdad47"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.process-one.net/en/ejabberd/downloads/"
    regex(/href=.*?ejabberd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c4873e5f20dc834c2b31e8a3a0a8e4b2c72ff0cc3f1af5de65236cf2823d6524"
    sha256 cellar: :any, arm64_big_sur:  "2c0f3a0d99e52c4e25e6844669929f992ee89514847532aa0cfff77aba2b1297"
    sha256 cellar: :any, monterey:       "2aab8f179a30fb248fd1e07a00ac149bd763451f11a385f916d1950e0dea5858"
    sha256 cellar: :any, big_sur:        "38f754a3aa6ef9c634104f39fd0c41e5d501525d69b437fd1520ff5544c1d01e"
    sha256 cellar: :any, catalina:       "383e3974b71e4d572c5f509b3b33f228eef34f18ab607633e632c387a9562863"
  end

  head do
    url "https://github.com/processone/ejabberd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "erlang@22"
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

    system "./autogen.sh" if build.head?
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
