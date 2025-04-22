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
    sha256 cellar: :any,                 arm64_sequoia: "7f8ce6f8fc4ad9a9431bc4a198f7baff60eb59cfc4bfa2f2ee2a879dba73b4c0"
    sha256 cellar: :any,                 arm64_sonoma:  "e786ed069ccafd35dfe1a21efe81f8c8a2b97d512b060bbd9d72373cdd5e9f9e"
    sha256 cellar: :any,                 arm64_ventura: "139bb7211f06a39509e9e5759357a31af3108d3d36b268ecb15f56b2489221ff"
    sha256 cellar: :any,                 sonoma:        "223e4a75a87232241f464c28e48861e165c7e5f55dd9756c5a0b1926eb2130e4"
    sha256 cellar: :any,                 ventura:       "97e0f7f141f0f3919d0545e0615be75309af3b48cdaf8963c804c3c896e715be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e986568af2e69ca634a7feca4308a3fd9320ebd8e0e619d15d7b2239af63f271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3149e4654d9a9013f4d13ae3e89f542ad2f82e105390e799c7ec0f0699fc0a3a"
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
    system sbin/"ejabberdctl", "ping"
  end
end
