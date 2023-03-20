class Daemontools < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "https://cr.yp.to/daemontools.html"
  url "https://cr.yp.to/daemontools/daemontools-0.76.tar.gz"
  sha256 "a55535012b2be7a52dcd9eccabb9a198b13be50d0384143bd3b32b8710df4c1f"
  revision 1

  livecheck do
    url "https://cr.yp.to/daemontools/install.html"
    regex(/href=.*?daemontools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3e38b536653bd1b7e2e8d0e98dca15f9085205d3eeed09d8d1787afe468a08b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f66a2fccba83ee8fe623c06d8b53dfb241cdeffd4af6ccdd8ac499c5b3191a2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4970abde6563bd8fa9cae9478b81d241ce0ad0c4d1504aa84269c55ccb45a499"
    sha256 cellar: :any_skip_relocation, ventura:        "73a2cd834d4b1ef90c48199eaaaba09f077d153252b1d383a4a619a211b1eab7"
    sha256 cellar: :any_skip_relocation, monterey:       "23c7f34339a55c30a0e32c45b200030e766eeae0fc7cc873de70bae175849123"
    sha256 cellar: :any_skip_relocation, big_sur:        "2de015542410e14eb8e17bb9affc37f19fc81e7005e4bec60ecd64c13629b02a"
    sha256 cellar: :any_skip_relocation, catalina:       "0a39db96c9e2926beea8224ca844264d4ddec3b6561d5dfc019f3ecfd7cc86fe"
    sha256 cellar: :any_skip_relocation, mojave:         "6516ee63288eab3eab3ee418ce070d711f483a5f6ebc147cb7039a9404bbaa0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d33be57d88799bbac35d167147869dbc93786d165d608a6e3286ff769af6343"
  end

  # Fix build failure due to missing #include <errno.h> on Linux.
  # Patch submitted to author by email.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/212baeaf8232802cf3dfbfcc531efa5741325bfa/daemontools/errno.patch"
    sha256 "b7beb4cfe150b5cad1f50f4879d91cd8fc72e581940da4a716b99467d3a14937"
  end

  def install
    cd "daemontools-#{version}" do
      inreplace ["package/run", "src/svscanboot.sh"] do |s|
        s.gsub! "/service", "#{etc}/service"
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
