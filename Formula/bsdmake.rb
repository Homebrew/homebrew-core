class Bsdmake < Formula
  desc "BSD version of the Make build tool"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/bsdmake/bsdmake-24.tar.gz"
  sha256 "82a948b80c2abfc61c4aa5c1da775986418a8e8eb3dd896288cfadf2e19c4985"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause-UC"]

  livecheck do
    url "https://opensource.apple.com/tarballs/bsdmake/"
    regex(/href=.*?bsdmake[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "8471df063ebf08e34ecc83482f48ac0758e62535f1046a83659ad83e0aecdedc"
    sha256 arm64_big_sur:  "e844047b809f9c3d3c297baebfcaaab0e5e0ee4cc993d4a8bb81c1db3ad372df"
    sha256 monterey:       "7ac963918bb1d8bf0a6be631304c0962179dc98348a94480e39c3024502abcb0"
    sha256 big_sur:        "a7540422211c370618f938241419971aa6542298a0735a8e369b612c1f639866"
    sha256 catalina:       "85bdfdf2ca2e5761195c4781e52232e4fb1258c99bf79f46cf82f66338197df3"
    sha256 mojave:         "acee008d57c2ebe6ad2ee5932d1521a254e16453c61cdd517da2c675f60c1eb4"
    sha256 high_sierra:    "fa009c31c9fa5fc71f774cfe146f1338ca856158a606b796c3a1e7dbd64f3895"
    sha256 sierra:         "3d5b8c21cf86cd6bb9eb28d1e8cbec434b370aa15e19540e366d045ea807c8c8"
    sha256 el_capitan:     "b4052277ac6cf79ed579107fb73da96954c350d7bf29a124c55d87a0df8940b0"
    sha256 yosemite:       "18d7cb56f14eb2e404cf3abb163a354f57c5e45b72991efdd6566a15fcffe90f"
  end

  # MacPorts patches to make bsdmake play nice with our prefix system
  # Also a MacPorts patch to circumvent setrlimit error
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1fcaddfc/bsdmake/patch-Makefile.diff"
    sha256 "1e247cb7d8769d50e675e3f66b6f19a1bc7663a7c0800fc29a2489f3f6397242"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1fcaddfc/bsdmake/patch-mk.diff"
    sha256 "b7146bfe7a28fc422e740e28e56e5bf0166a29ddf47a54632ad106bca2d72559"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1fcaddfc/bsdmake/patch-pathnames.diff"
    sha256 "b24d73e5fe48ac2ecdfbe381e9173f97523eed5b82a78c69dcdf6ce936706ec6"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1fcaddfc/bsdmake/patch-setrlimit.diff"
    sha256 "cab53527564d775d9bd9a6e4969f116fdd85bcf0ad3f3e57ec2dcc648f7ed448"
  end

  def install
    # Replace @PREFIX@ inserted by MacPorts patches
    # Use "prefix" since this is sometimes a keg-only brew
    # But first replace the X11 path if X11 is installed
    inreplace "mk/sys.mk", "@PREFIX@", MacOS::XQuartz.prefix || prefix
    inreplace %w[mk/bsd.README
                 mk/bsd.cpu.mk
                 mk/bsd.doc.mk
                 mk/bsd.obj.mk
                 mk/bsd.own.mk
                 mk/bsd.port.mk
                 mk/bsd.port.subdir.mk
                 pathnames.h],
                 "@PREFIX@", prefix

    inreplace "mk/bsd.own.mk" do |s|
      s.gsub! "@INSTALL_USER@", `id -un`.chomp
      s.gsub! "@INSTALL_GROUP@", `id -gn`.chomp
    end

    # See GNUMakefile
    ENV.append "CFLAGS", "-D__FBSDID=__RCSID"
    ENV.append "CFLAGS", "-mdynamic-no-pic"

    system "make", "-f", "Makefile.dist"
    bin.install "pmake" => "bsdmake"
    man1.install "make.1" => "bsdmake.1"
    (share/"mk/bsdmake").install Dir["mk/*"]
  end

  test do
    (testpath/"Makefile").write <<~EOS
      foo:
      \ttouch $@
    EOS

    system "#{bin}/bsdmake"
    assert_predicate testpath/"foo", :exist?
  end
end
