class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/24.12.tar.gz"
  sha256 "22b15ab9be8f0ac4b7a5a7a48cd59c282c87f17b038017b960c15cfd314689f2"
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
    sha256 cellar: :any,                 arm64_sequoia: "171e56db81d3ebd5362569c704bb73b4e69951b3d4570ffe708c9ada479b2b93"
    sha256 cellar: :any,                 arm64_sonoma:  "b30eabf8ae62380df07fcfcb0a066049300b0775248b41563cb266f58b8386aa"
    sha256 cellar: :any,                 arm64_ventura: "5fe268b11de8693d05c2a6f87572db4df63ed17a0d4c6ac5b66d95db6bf9205a"
    sha256 cellar: :any,                 sonoma:        "c2cf04d02ee1f53f3757a47f41c31a659978a2ef8724624209eff7c0de9de67f"
    sha256 cellar: :any,                 ventura:       "cd02e39ca82d4323d075e135fa427a37cfa38960bc205f102d32db64a73dc6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc37a4a6eaa6db25ff1d6d3508d08cb30442010423a2de4f2128712838a0b874"
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
