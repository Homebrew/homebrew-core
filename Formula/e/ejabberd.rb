class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/25.03.tar.gz"
  sha256 "27df1ed8123ecc3139a573ee254e8a584392f759f5c23a0825662ca1df0cb62c"
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
    sha256 cellar: :any,                 arm64_sequoia: "12348123d1d2424b9829849d916dec6f3e1fda627a87353fe7595ee067b23fac"
    sha256 cellar: :any,                 arm64_sonoma:  "58a410a95022f3675d1912eee3a94bdfc9c813bf8ec8a199d9264f38785a3114"
    sha256 cellar: :any,                 arm64_ventura: "fbdf17eb3270829f0b2f361d1ebbd92c6f0abedddf01e9bbb196927d5eb80d88"
    sha256 cellar: :any,                 sonoma:        "a02f4dd82fabcb00f16111fe491f3b20f6e25325989e7b9c1f953266af008f0b"
    sha256 cellar: :any,                 ventura:       "23d89cff686a63b6ace8445d55d37c46a2bcbeb17b6e978b79f9be60c4ae3a1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aec8ad7e055350acaae886befc95da8c986b5c27630602b156e02056e0cbd5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b601a389cb5473d48b28947c12a84485d641a91a7d5d8145ef72acb6ea9686b"
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
