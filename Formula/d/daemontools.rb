class Daemontools < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "https://cr.yp.to/daemontools.html"
  url "https://cr.yp.to/daemontools/daemontools-0.76.tar.gz"
  sha256 "a55535012b2be7a52dcd9eccabb9a198b13be50d0384143bd3b32b8710df4c1f"
  license :public_domain
  revision 2

  livecheck do
    url "https://cr.yp.to/daemontools/install.html"
    regex(/href=.*?daemontools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5f93a24d9a69ffa3bad993a4a92a5ebc5023ac175741f71d5a61491f01a1c1c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4d55eb82da586265d67f9fdb355715ee396417a002ed2e121d40b51ac3d0863"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "991fcc92f0c958384e3f434fab21761059a51fa58cac8c345ce61cfc98972863"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c9a82746468fb2b1eaea00ff04d1202099d6a0af27dc7e6287f1745a44028e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6835770574462a78160eb7c9d9139b18a493804b5984409a549b394eb90c5fe5"
    sha256 cellar: :any_skip_relocation, ventura:        "265702ded875f506c1e35e56c8620cb108fce3dd6ed2b5809e792e15c26a0509"
    sha256 cellar: :any_skip_relocation, monterey:       "e57d6d6f618a545f245c2465038d63946310aa08e887eda8526dd154aff9db21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b6e2a4ebdbbc3105db2cc0425d85d782a5f0cccd10def1e0a7c63c05e13c2b1"
  end

  # Fix build failure due to missing #include <errno.h> on Linux.
  # Patch submitted to author by email.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/212baeaf8232802cf3dfbfcc531efa5741325bfa/daemontools/errno.patch"
    sha256 "b7beb4cfe150b5cad1f50f4879d91cd8fc72e581940da4a716b99467d3a14937"
  end

  # Fix build failure due to missing headers for POSIX-related functions.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e52085ff249263bdf9a21229e0d806ea4e2b9e95/daemontools/posix-headers.patch"
    sha256 "288afdf9b7ba4f05a791f714ddea22b0a18020f54face020e45311135f0c92c1"
  end

  def install
    cd "daemontools-#{version}" do
      inreplace ["package/run", "src/svscanboot.sh"] do |s|
        s.gsub! "/service", "#{etc}/service"
        s.gsub! "/command", bin.to_s
      end

      # Work around build error from root requirement: "Oops. Your getgroups() returned 0,
      # and setgroups() failed; this means that I can't reliably do my shsgr test. Please
      # either ``make'' as root or ``make'' while you're in one or more supplementary groups."
      inreplace "src/Makefile", "( cat warn-shsgr; exit 1 )", "cat warn-shsgr" if OS.linux?

      system "package/compile"
      bin.install Dir["command/*"]
    end
  end

  def post_install
    (etc/"service").mkpath

    Pathname.glob("/service/*") do |original|
      target = "#{etc}/service/#{original.basename}"
      ln_s original, target unless File.exist?(target)
    end
  end

  def caveats
    <<~EOS
      Services are stored in:
        #{etc}/service/
    EOS
  end

  service do
    run opt_bin/"svscanboot"
    keep_alive true
    require_root true
  end

  test do
    assert_match "Homebrew", shell_output("#{bin}/softlimit -t 1 echo 'Homebrew'")
  end
end
