class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/24.02.tar.gz"
  sha256 "b6d48d3bf2bef368e9321e35436381c86d78444b9042649c6c4aab0089395c07"
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
    sha256 cellar: :any,                 arm64_sonoma:   "068453fc248200e5a6a59323732cff760d9e4c6d5a8b73420abde241210d4399"
    sha256 cellar: :any,                 arm64_ventura:  "a8ed53effb98f9ee0d01085db4a288add52967e9a2d90186a833b093b8eddef8"
    sha256 cellar: :any,                 arm64_monterey: "c16f30356c6ac475cdf0b649dbb574e8de3ab8073124ffc6277fd77b0922e5ea"
    sha256 cellar: :any,                 sonoma:         "dd5d709e3bfd463ae3dc1eee3660671e4fd1c2cc8109538600697bbb2458b5d2"
    sha256 cellar: :any,                 ventura:        "51135a589be16e436213e110364bc8a5533bf81791ef59ac44ac1a1014b3b701"
    sha256 cellar: :any,                 monterey:       "265918def8d32a2e7039be0e39545f51f9885567297f62dd17084af9e6f7a3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a4c9da21319520782311e5f1e312adfe4b197abe29fd7647d84f71f1e25cb3f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "erlang"
  depends_on "gd"
  depends_on "libyaml"
  depends_on "openssl@3"

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
