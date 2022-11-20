class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/22.10.tar.gz"
  sha256 "8539707da7e75785444edf402b5ff60fc3f956806c341b2565702dcc77900402"
  license "GPL-2.0-only"
  head "https://github.com/processone/ejabberd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4f40e6ce813d70e58b60e2da13c0e7cc694fcc300f8a92c2159034b2414ad3d"
    sha256 cellar: :any,                 arm64_monterey: "baae4960d92ae5d21d82382c3202bb9150b414d50ce97c8bdb756e4d3f777594"
    sha256 cellar: :any,                 arm64_big_sur:  "3d3c3ce2dc52cfcd45b6e177c027f4e2b782ccdedf0aa81e458153725e5fac27"
    sha256 cellar: :any,                 ventura:        "4cb756ab8aee7a8ef6fdac0cc81a09038bbae23f1b77c2f2e2f768d1d1d321f9"
    sha256 cellar: :any,                 monterey:       "ef80593e0e0e03cc10393f861aaf209019dfd1f175a58b352e47a7ad6d2c73b7"
    sha256 cellar: :any,                 big_sur:        "e379ec46b088099a3a323ed05c4d519894639c932ce28616ab69de8cb2b56aba"
    sha256 cellar: :any,                 catalina:       "1b7baed8ffa349d7b02c7e0bf865d7c1506a116ea1a9ca07f1e5431bb572d018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb251bbf28ec6219f6200bbc23bf2a6733b85348f8d1d8454db23f8cb7276200"
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
