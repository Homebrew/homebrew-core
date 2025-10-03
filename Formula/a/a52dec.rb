class A52dec < Formula
  desc "Library for decoding ATSC A/52 streams (AKA 'AC-3')"
  homepage "https://git.adelielinux.org/community/a52dec/"
  url "https://distfiles.adelielinux.org/source/a52dec/a52dec-0.8.0.tar.gz"
  sha256 "03c181ce9c3fe0d2f5130de18dab9bd8bc63c354071515aa56983c74a9cffcc9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://distfiles.adelielinux.org/source/a52dec/"
    regex(/href=.*?a52dec[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ca731a1b2d531c0e169e56a7d02c72dc18e0fb163fac344f7476fe0e399bec7b"
    sha256 cellar: :any,                 arm64_sequoia:  "bb6e3408f39a404770529cfce548dc2666e861077acd173825cb3138c27c205a"
    sha256 cellar: :any,                 arm64_sonoma:   "9619e592adb641635b8bc648e92149822e6564203088f33570c2da72283ba918"
    sha256 cellar: :any,                 arm64_ventura:  "1f40eee1f2254ecbeee873473dba633d2cc52f295aedb0ae3ae82db198d0c5b9"
    sha256 cellar: :any,                 arm64_monterey: "61a272a68f11e79ba690068f532728eda218a9d86f330d070826bf003aedacfa"
    sha256 cellar: :any,                 arm64_big_sur:  "24dae57187519f6ef5449df29562fa9d752d1844d00f2590bf5bb2b38213fd84"
    sha256 cellar: :any,                 sonoma:         "20ad4b441da0829f26e28c1ed1c6580af78d078a9393c97af3d5fa66a7d3c0dc"
    sha256 cellar: :any,                 ventura:        "d365954f1957b92868f9a3335509eff98e4d52437b75a868165742c6849555d6"
    sha256 cellar: :any,                 monterey:       "36ff9fa73cae7a8d1850cafa0f75d27df33d5f8bf5d57bf10a064de09e234194"
    sha256 cellar: :any,                 big_sur:        "cf1809cf8444fb50bbbe685e0f8ac697b84969cc0662d5079fa817c8eadd1ec3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b81010ab1db1eb4740dc4a587fdee7a4340873c6a61d16b17c51bb6ac33371f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a3d786826405966046c6962db674c563b89e86bf9ff5a53aecb9cea18f4df3d"
  end

  def install
    # Fixes duplicate symbols errors on arm64
    ENV.append_to_cflags "-std=gnu89" if OS.mac?

    system "./configure", "--disable-silent-rules",
                          "--enable-shared",
                          *std_configure_args
    system "make", "install"
  end

  test do
    touch testpath/"test"
    system bin/"a52dec", "-o", "null", "test"
  end
end
