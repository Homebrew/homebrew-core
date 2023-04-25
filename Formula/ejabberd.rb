class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/23.04.tar.gz"
  sha256 "6ff1d41a1ff6261a0c846193647d8ec143e82142859bf1cfdc62299022ceb2ad"
  license "GPL-2.0-only"
  head "https://github.com/processone/ejabberd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6c8c5f22707e22da9b8e35ef4aa8571e37cf8c3b0398b4f0e6fababb33597a58"
    sha256 cellar: :any,                 arm64_monterey: "85bb55f4d66995b5b9d0bfe9f45f5de651c12bef81f67922e209ed79ce3f3040"
    sha256 cellar: :any,                 arm64_big_sur:  "9d05ae8d35adb90245aa012b13afc413ed90de4ebf6d4284e4cdbfcec149c7e1"
    sha256 cellar: :any,                 ventura:        "3be78bfbb812e8fdf1d58dd1029e2d8cca8f7e51ec94356481e1f91bd747a493"
    sha256 cellar: :any,                 monterey:       "b5711831bc1552cc20b4db8ed51ce8a0a4ccb112b73b14ef3fd8cf1338d7b34c"
    sha256 cellar: :any,                 big_sur:        "bdb207db5ad5bbad2bc8204ad205a62d2bd79176acf0e94648d0198337397e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "959d76634a02d0de06a82a6f81ba773a11cefc229cbc82fdf8b804ac4f8a4b7e"
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
