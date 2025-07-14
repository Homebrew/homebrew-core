class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/25.07.tar.gz"
  sha256 "a980f2817ea03ca78dc5d8d241ba68a533cbcfe371996513a1b24ea371146596"
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
    sha256 cellar: :any,                 arm64_sequoia: "60636a79e84951d029bdaa309e0191efd6ebbabf07636fad59172311864769e9"
    sha256 cellar: :any,                 arm64_sonoma:  "e74a508b0b166b93709bcb3d229550458549790db92d47f6805d04f102f4d8eb"
    sha256 cellar: :any,                 arm64_ventura: "66b369ae6ef3119398eaf3c3ed3f3e626a22e29500a9b0a689bf43bea85964cc"
    sha256 cellar: :any,                 sonoma:        "aec0e885f76d1ddf5b8d14c4f2f2d5350a4125988deba8c2dafea994f36a45f5"
    sha256 cellar: :any,                 ventura:       "a088e67b83a0b822a3eb3e7f9ba22dc0e913b1d83f27fac889c7afb278e9b161"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a80e69ef6c6a2d8f61b2c41f3a0f3c1ded58f93c91203ee7942297f606bdb354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b8a7d7b4aac252e9bcde89c3b2302d4e2ec20ef0acc0d3345642e51a2b713ca"
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
