class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/23.04.tar.gz"
  sha256 "6ff1d41a1ff6261a0c846193647d8ec143e82142859bf1cfdc62299022ceb2ad"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/processone/ejabberd.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "687e3185fc9379d6ba0ef009d3cc8c945695e5afff1f8b3ea66a91b2f76734b8"
    sha256 cellar: :any,                 arm64_ventura:  "036f0e2d4def5984d21c0f88383cad4bbac2788aaac7297eece2c5439bcec510"
    sha256 cellar: :any,                 arm64_monterey: "21f63aa97ffaffdacbdf41bd0a5dc13ab2f1295f5b1c6ab0a74619da0f49fe6a"
    sha256 cellar: :any,                 arm64_big_sur:  "d1d6f94b9fb6e4288512e769410a9e94bb094e8badf4854e0f3ea63d63621ef5"
    sha256 cellar: :any,                 sonoma:         "58e3770239e011e2a20dfea70d007a333a6bcb7748eda8c1a4282dab7dcf2573"
    sha256 cellar: :any,                 ventura:        "7107a594996d7113a855607f0411002a456692cbf29b688b3438a7f9efe6e503"
    sha256 cellar: :any,                 monterey:       "281a28e55f2d028ebc1c448acd8bb033e76615cd0e5c88efd31fabdec73b9ad6"
    sha256 cellar: :any,                 big_sur:        "7223e13c94f09c133ba7af5ac2151101443d1a1a2437ba20e73df89ce4d96a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b01c59f4459ec7a85894e30d0519d532ec65f9657129fabb5f4e2499cf7403a4"
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
