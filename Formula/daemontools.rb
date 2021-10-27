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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f66a2fccba83ee8fe623c06d8b53dfb241cdeffd4af6ccdd8ac499c5b3191a2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4970abde6563bd8fa9cae9478b81d241ce0ad0c4d1504aa84269c55ccb45a499"
    sha256 cellar: :any_skip_relocation, monterey:       "23c7f34339a55c30a0e32c45b200030e766eeae0fc7cc873de70bae175849123"
    sha256 cellar: :any_skip_relocation, big_sur:        "2de015542410e14eb8e17bb9affc37f19fc81e7005e4bec60ecd64c13629b02a"
    sha256 cellar: :any_skip_relocation, catalina:       "0a39db96c9e2926beea8224ca844264d4ddec3b6561d5dfc019f3ecfd7cc86fe"
    sha256 cellar: :any_skip_relocation, mojave:         "6516ee63288eab3eab3ee418ce070d711f483a5f6ebc147cb7039a9404bbaa0a"
  end

  def install
    cd "daemontools-#{version}" do
      inreplace ["package/run", "src/svscanboot.sh"] do |s|
        s.gsub! "/service", "#{etc}/service"
      end

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

  plist_options startup: true

  service do
    run opt_bin/"svscanboot"
    keep_alive true
  end

  test do
    assert_match "Homebrew", shell_output("#{bin}/softlimit -t 1 echo 'Homebrew'")
  end
end
