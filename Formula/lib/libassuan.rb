class Libassuan < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  # TODO: On next release, check if `-std=gnu89` workaround can be removed.
  # Ref: https://dev.gnupg.org/T7246
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-3.0.2.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-3.0.2.tar.bz2"
  sha256 "d2931cdad266e633510f9970e1a2f346055e351bb19f9b78912475b8074c36f6"
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
    sha256 cellar: :any,                 arm64_tahoe:   "0561b0dae24dbd1bfb2ebcc1b6ca6b4f10cab80d30a73558b8b87ab129415dc5"
    sha256 cellar: :any,                 arm64_sequoia: "1430611fe9f337d6a7568a12321f125c567ca8d4d2bdcd7ff0717bdcd82a32dc"
    sha256 cellar: :any,                 arm64_sonoma:  "59e577c969d60c328976822c4d5bdfa5b5b11231453573e9c1bddc308e211126"
    sha256 cellar: :any,                 arm64_ventura: "2c97f2188ef55d1de16938e270797b3ecc59315cd09f03ca347a533c6e57efd4"
    sha256 cellar: :any,                 sonoma:        "0ec4ad2607107d27bb8b0acb1f7fb3a81c8bea66ed17b69afbd6bec70a9a5b98"
    sha256 cellar: :any,                 ventura:       "be83f28dfef1934dd05a2a2f1523398bf9a6927b0b80c42447f4b18583e6dc25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1cc44ec4ce43e405be679fbee9a434a7bdbf86f267ac946cb4a8642cdf89df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "620108c517ecfeb00c843bd34f86b75bf84c1bd92be9b554c86424fad3b99f08"
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
