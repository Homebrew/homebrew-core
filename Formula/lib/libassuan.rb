class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  # TODO: On next release, check if `-std=gnu89` workaround can be removed.
  # Ref: https://dev.gnupg.org/T7246
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-3.0.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-3.0.1.tar.bz2"
  sha256 "c8f0f42e6103dea4b1a6a483cb556654e97302c7465308f58363778f95f194b1"
  license all_of: [
    "LGPL-2.1-or-later",
    "GPL-3.0-or-later", # assuan.info
    "FSFULLR", # libassuan-config, libassuan.m4
  ]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libassuan/"
    regex(/href=.*?libassuan[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d53cede9f63eafcea91f251c981b77d8fd3a1c154f18fbdef96e723bd4735af8"
    sha256 cellar: :any,                 arm64_sonoma:   "a8ee8c0ab1f375a63461302a4cd02d0d637ffcb1dea275fedcadd809760d782e"
    sha256 cellar: :any,                 arm64_ventura:  "8184558f48ab9800dc30a504eb75280cf5045e4d7b88ba47b5413d37f70c72c2"
    sha256 cellar: :any,                 arm64_monterey: "2ffaccce9f611cf5393cbe11dfc1b5ae06b17facc470e0c2bc0412ab99ba3a05"
    sha256 cellar: :any,                 sonoma:         "163ccdbb162a2ff51d976ea875d5d5ff27e743967199991ffa9932a090b12287"
    sha256 cellar: :any,                 ventura:        "432ad61d2bb3d4d37085af8a3195e291c587be9d8f500c196ac8b77e30b0123a"
    sha256 cellar: :any,                 monterey:       "9028c16a9be579ffa059f778586b841319e8c05537177684737d01f552b190f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72bb9308d12fb7ff5f41b91805da04e1246521d6f33b9ef4b712ca6d70385b7f"
  end

  depends_on "libgpg-error"

  def install
    # Fixes duplicate symbols errors - https://lists.gnupg.org/pipermail/gnupg-devel/2024-July/035614.html
    ENV.append_to_cflags "-std=gnu89"

    system "./configure", "--disable-silent-rules",
                          "--enable-static",
                          *std_configure_args
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libassuan-config", prefix, opt_prefix
  end

  test do
    system bin/"libassuan-config", "--version"
  end
end
