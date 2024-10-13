class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://github.com/processone/ejabberd/archive/refs/tags/24.07.tar.gz"
  sha256 "c0fb746acba81a5db41de97c03968c1f681a13b1b6c1a895b7182e33820c18d9"
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
    sha256 cellar: :any,                 arm64_sequoia:  "c1a655bd9884cb96b43c4d8cbe8a3eeb0dd4a45aaab6470ee8d47f7af681d7be"
    sha256 cellar: :any,                 arm64_sonoma:   "e79b2a45c9f6d51aed4f4776bbe927276431a86dd76c0f52a720eecf66b456ea"
    sha256 cellar: :any,                 arm64_ventura:  "fe3919aa9fe2182145c76330e27a0cfe37f5e140994e199d89760275b3730105"
    sha256 cellar: :any,                 arm64_monterey: "e6d14fc6089d0dce483bcc972b7c84418c4775aeb333cf76eb61aa143b0b53d0"
    sha256 cellar: :any,                 sonoma:         "c5d49911266df35a8937f166b77277b69b4ddf2d6f27840c04cefdde5bd2a47f"
    sha256 cellar: :any,                 ventura:        "a88d2df0fddc8dc859dc13a8adbc7fce624d15235392efa2ecef5c8ec8cfaff5"
    sha256 cellar: :any,                 monterey:       "3485b3cb3788b82bf95a69cfea4ba936ca4db69517c5fc51c3c30d726bdca9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "669a615d3280734af6a3563a091aded19b6e1db2380b12178102daca8fe8fe90"
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
