class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/25.04.tar.gz"
  sha256 "54beae3e7729fdaab1d578a9d59046f31d8ce31c851ae5aca9532821ff22cb45"
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
    sha256 cellar: :any,                 arm64_sequoia: "67076a615179ef3c1dd45faef296c14cbc9f4dee06e410c7b6211d3b54085d52"
    sha256 cellar: :any,                 arm64_sonoma:  "7570204be8347f68e4af4d0ff2f90fd5647176afffb736c72889dfd78aa20721"
    sha256 cellar: :any,                 arm64_ventura: "22fbe091ca7bd864c5dd6675f7502eb980d15673c2070092ad534a9a42657a15"
    sha256 cellar: :any,                 sonoma:        "93f654bbfa377040b85833fc42c0dd78f0900e659a830badae2a13b5e920cc17"
    sha256 cellar: :any,                 ventura:       "795e5517d4db61c6f1a3587390a86abfd170517e783e2c31fcf6f886fd681cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cdfb5ee00a14b740d6123f99b57e791e1f09915790a0bc6d248d94656f9c8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf2a76d61c04d535e3183a9db385199f852a8437eda93e8c8d5e0a0dddf200fa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "erlang@27" # https://github.com/processone/ejabberd/issues/4354
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
    system sbin/"ejabberdctl", "ping"
  end
end
