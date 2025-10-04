class LibassuanAT2 < Formula
  desc "Assuan IPC Library"
  homepage "https://www.gnupg.org/related_software/libassuan/"
  url "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.7.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libassuan/libassuan-2.5.7.tar.bz2"
  sha256 "0103081ffc27838a2e50479153ca105e873d3d65d8a9593282e9c94c7e6afb76"
  # NOTE: We exclude LGPL-3.0-or-later as corresponding code is only used on Windows CE.
  license all_of: [
    "LGPL-2.1-or-later",
    "GPL-3.0-or-later", # assuan.info
    "FSFULLR", # libassuan-config, libassuan.m4
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "8605812fa5527576a5b1eb54049a068fda2444fcb1a3bfc6d04787dc3b2a59ad"
    sha256 cellar: :any,                 arm64_sequoia:  "24910ee0977d721b85bd2df1372698beaa6d11716b81e7a49512ccc9c79ba4da"
    sha256 cellar: :any,                 arm64_sonoma:   "0d4fd656fbf3db20892da64bec2eb966842de215a23c2008ecdf9198a68d5211"
    sha256 cellar: :any,                 arm64_ventura:  "22fd67c9fe966a0dfb7b26546828ef966ce53ece9ef297114932ea657927395f"
    sha256 cellar: :any,                 arm64_monterey: "bfb5e94cf8e6416253a63a0161fd1ae6f3665d71b4f83bacefea4043ae2f46b4"
    sha256 cellar: :any,                 sonoma:         "bbe02b3b1091f71a05a2849bc67427e99073dcdede197a16bd18b679306d65c9"
    sha256 cellar: :any,                 ventura:        "f74779f1dc1d827a4a57186d83e2398c524ff4b82abdefd4e5f7148b7fd46612"
    sha256 cellar: :any,                 monterey:       "8827e9ad490c7273044aef10a0342cd85c0d72c6407f515b38445d53e4cc2605"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "67dc8df4e57fde8c74851d163d6a1716eb9fdebbc884b8a2be0a2363f92f1b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a769126855958b4ffa4793c21b0d5e6f8281459dbd42d9931adfb9768b0350d"
  end

  keg_only :versioned_formula

  deprecate! date: "2025-01-11", because: :versioned_formula

  depends_on "libgpg-error"

  def install
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
