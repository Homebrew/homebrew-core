class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/25.08.tar.gz"
  sha256 "edc95cff239d74bfb16e437f7cf84f0e86144e5fe764d7ee7dc248b2d59778f1"
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
    sha256 cellar: :any,                 arm64_tahoe:   "7d5e2a36b0f3d717927452da6f8066e73a4e523527b7fe09588fbb1f32221be2"
    sha256 cellar: :any,                 arm64_sequoia: "04ef35f86b87b1e83c9ef82de30b418a7effe4745725cc33a04f2696c569cc1d"
    sha256 cellar: :any,                 arm64_sonoma:  "3b51176e909eb1e14f27fbf51e836905b5768126464b7c23125e2c00bf54cdb4"
    sha256 cellar: :any,                 arm64_ventura: "bc5a0c0a5e1022f9f57b7f179447c1111b352045886a19a04611e3b678658807"
    sha256 cellar: :any,                 sonoma:        "3b52f941d9f4e9f71a9bb7456a0cbd4b81771a6326884d17da34ecdafe68e496"
    sha256 cellar: :any,                 ventura:       "7af2770db7fed11d93a7a3dda7895cdbe1d8300608fcbd023af3ab7723e07532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71bb656be7d9b889df61d0d3771769a97371e867543891e6f9e1ae3b42aadf23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fb2592163e17b031217ecfddd0d91bdf4d1f990dbd59b518e131a2216226e58"
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
