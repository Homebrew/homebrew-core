class Btparse < Formula
  desc "BibTeX utility libraries"
  homepage "https://metacpan.org/dist/Text-BibTeX/view/btparse/doc/btparse.pod"
  url "https://cpan.metacpan.org/authors/id/A/AM/AMBS/btparse/btparse-0.35.tar.gz"
  sha256 "631bf1b79dfd4c83377b416a12c349fe88ee37448dc82e41424b2f364a99477b"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6bcfac3d46e83b1217a57419de338fbea65b77c71d9a4f6de49665990e93b746"
    sha256 cellar: :any,                 arm64_sequoia:  "7da3060367c602412a91935267f6f8eef48d2c15fc0e5fcfd7a8bc42423ba281"
    sha256 cellar: :any,                 arm64_sonoma:   "783d3d629c204b19bfcfa7e64dc138f89432392c29838999b95364d814ab6445"
    sha256 cellar: :any,                 arm64_ventura:  "d58ac5298bb8bfc1859e5333d541ea89ce1dba5a629c1360b48857eb307f6350"
    sha256 cellar: :any,                 arm64_monterey: "32ee64dd04210dd27edb63ba2d3a635995f379e54d60b9e797e52a913201b546"
    sha256 cellar: :any,                 arm64_big_sur:  "d69e49048e5366097bd7fe06b5ab9e40e3e97602896c613706559ab2c7aa4295"
    sha256 cellar: :any,                 sonoma:         "2c03d25c93b9dd5a6ef76494499f0504d38fec90f3e098fced14b4f9b1bf0236"
    sha256 cellar: :any,                 ventura:        "79122577ccff4c437a09ca3d3a7f0fcb5270ff5b1b90be60442f420c3e1ee830"
    sha256 cellar: :any,                 monterey:       "3330e9fe95565967827105cbe3009bf533b1363f8b4454c3fa34a7bca72f9502"
    sha256 cellar: :any,                 big_sur:        "6080f2a4c252d49a4b265807ce77c290bd881b5339b7b2c19c5efc8a7f40b871"
    sha256 cellar: :any,                 catalina:       "6ce6b4e17c2559540007f3e15e38ee5f4eff1cc5dd6782e87089abf824a94e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a38cb6010173a8291ff7f70a323775f1131adfcdb6a755a7ebdf3e8269397353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb28ef3caa60d179c008ab9fbd54395014c35119cb9b1c1f2168a3e6bde294d0"
  end

  def install
    # workaround for Xcode 14.3
    if DevelopmentTools.clang_build_version >= 1403 || (OS.linux? && Hardware::CPU.arm?)
      ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
    end

    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--mandir=#{man}", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<~BIBTEX
      @article{mxcl09,
        title={{H}omebrew},
        author={{H}owell, {M}ax},
        journal={GitHub},
        volume={1},
        page={42},
        year={2009}
      }
    BIBTEX

    system bin/"bibparse", "-check", "test.bib"
  end
end
