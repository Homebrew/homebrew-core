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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da992fd278ff1a26880a1a254f7a54e2440ef886c565bef4d52335a53a0efe99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5272511ffc8ff84d1a6a86ff7a4b643530c9d1feab3cfca5b70cea23e7855ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e6c9db0f8c6137035c15da9445fbdac2dfd0475eb3ae3bb563237affe0f6867"
    sha256 cellar: :any_skip_relocation, sonoma:        "9181744087c4ab10deb008bfd08bb892ba7c00dd6cfa092be93c8fb37018c659"
    sha256 cellar: :any,                 arm64_linux:   "2b086e3eb960e1f213b829504158a83246c196cbbad30e548d0bdd396ef8292b"
    sha256 cellar: :any,                 x86_64_linux:  "ec457300fd92eaf1f7f3fad1e5a7904b9f02665b85d78b5e4628d176bc0a4008"
  end

  resource "man" do
    url "https://deb.debian.org/debian/pool/main/d/daemontools/daemontools_0.76-8.1.debian.tar.xz"
    sha256 "b9a1ed0ea88172d921738237c48e67cbe3b04e5256fea8ec00f32116c9ef74c0"
  end

  # Fix build failure due to missing #include <errno.h> on Linux.
  # Patch submitted to author by email.
  patch do
    file "Patches/daemontools/errno.patch"
    type :unofficial
  end

  # Fix build failure due to missing headers for POSIX-related functions.
  patch do
    file "Patches/daemontools/posix-headers.patch"
    type :unofficial
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

  post_install_steps do
    mkdir_p "service", base: :etc
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
