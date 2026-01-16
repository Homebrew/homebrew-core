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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d2dc1ed742ae4b8ab911aef610c8315ea79b9dce79a4a9d21028f413352bd6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1caba2a88c37b416bf48c950f376693b1412a06f54bc62c815a6e8679f30b41d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4079bdac80d383b3423b5daf190a2abc5583db2d5e33939ccd0e3c637ab57033"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "414c519a3f46d28c74e28d95f882b68dae09dcd9604b8f207c93539d4af34cd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2fbc29b09bf37004b7a31ff2a7f57bd705e757cef0b1970b2b9723f624bc8d9"
    sha256 cellar: :any_skip_relocation, ventura:       "813c64aa076209409ab420484007a7d43e7bfa86ce26842829d8800501e9b138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78eeabb0f8b6f6d678f97dfcf0a84e51c1b0f667e5fba8c6a1ef4707f85a91ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f527c08fac6754686403613d81fe344434ead8477130d596ffa05862b4962fe"
  end

  resource "man" do
    url "https://deb.debian.org/debian/pool/main/d/daemontools/daemontools_0.76-8.1.debian.tar.xz"
    sha256 "b9a1ed0ea88172d921738237c48e67cbe3b04e5256fea8ec00f32116c9ef74c0"
  end

  # Fix build failure due to missing #include <errno.h> on Linux.
  # Patch submitted to author by email.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/daemontools/errno.patch"
    sha256 "b7beb4cfe150b5cad1f50f4879d91cd8fc72e581940da4a716b99467d3a14937"
  end

  # Fix build failure due to missing headers for POSIX-related functions.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/daemontools/posix-headers.patch"
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

    resource("man").stage do
      man8.install Dir["daemontools-man/*.8"]
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
