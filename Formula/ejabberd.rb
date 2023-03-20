class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/23.01.tar.gz"
  sha256 "2b83fe036bbf1db8a76b86f718ff13df098fa10c62bfcf06b81e0a64e6f6f9c0"
  license "GPL-2.0-only"
  head "https://github.com/processone/ejabberd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "492a5decbdf53a7cc6de09e8adb83e35c7f474e60962f4087091a690ddc7cc7f"
    sha256 cellar: :any,                 arm64_monterey: "08f2e458dc00851637c74a591638b055b8ef0603966342fc6ea8ff62ee62f190"
    sha256 cellar: :any,                 arm64_big_sur:  "7507a254caef8e7fc164b244868c61bd6755b17c3f6623b89a850d00a05dfc58"
    sha256 cellar: :any,                 ventura:        "bd954e8458b31c916861ace7caad2d91cf40d09da0cb6df167df3cf29a8da43d"
    sha256 cellar: :any,                 monterey:       "38735f02ae335db76cb5aba10e5f3d54c9a5c975ddec56b4e7669d106cb7912e"
    sha256 cellar: :any,                 big_sur:        "535da5433240eb922934a1cf2c00f935a531a38f5aba5f6dbd9f1afee28f569f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82774030f80c254d36e349ef3b3cc99498a6aaad9d14d43ccb29acfeef3a7ed6"
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
