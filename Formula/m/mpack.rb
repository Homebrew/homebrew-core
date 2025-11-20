class Mpack < Formula
  desc "MIME mail packing and unpacking"
  homepage "https://web.archive.org/web/20190220145801/ftp.andrew.cmu.edu/pub/mpack/"
  url "https://ftp.gwdg.de/pub/misc/mpack/mpack-1.6.tar.gz"
  mirror "https://fossies.org/linux/misc/old/mpack-1.6.tar.gz"
  sha256 "274108bb3a39982a4efc14fb3a65298e66c8e71367c3dabf49338162d207a94c"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "39ef950b3be79638f72addb1f2bd87c4c67f9bddeb55f62910175ab6c90b6dc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93385223f8645ef28a3a518b5eb932d7b17a55bc113fd22522190c5504670b1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6aab109b96f77c14fb2f445ef2e1da17f9bb28169c9aef6e7806f32df5b6143d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ddea83dccaf311d5310e4147a3ba9a80523326bce98af5200e2e7bec7cc0782"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7a9affafe46b5198dc95c2b0cfb4bf9514f6a58d43fae6524b735a6a9cf76a1"
    sha256 cellar: :any_skip_relocation, ventura:        "1cd7be9284fb871ac17b2cd0be687719104fa5a792c608f22f875c21c3fed004"
    sha256 cellar: :any_skip_relocation, monterey:       "1622ba058cfb546fae179857ce3a9878d770ae2a16c801b3ef019c39a7a40a66"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "078f23d93e4a983bd4ac5fe1be780f900e3ddbb1258e9544388afa43534974eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f75abfc3198ea5dfd73192c148cf90a0a01e80143acde96fc9f18ff63e3e9514"
  end

  deprecate! date: "2024-07-21", because: :repo_removed
  disable! date: "2025-07-26", because: :repo_removed

  # Fix missing return value; clang refuses to compile otherwise
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/mpack/uudecode.c.patch"
    sha256 "52ad1592ee4b137cde6ddb3c26e3541fa0dcea55c53ae8b37546cd566c897a43"
  end

  # Fix build failure because of missing include statements on Linux.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/mpack/linux.patch"
    sha256 "3123446e13b34a083cab8408e16fce0a4dba78c170887722f4cd4306798c54d0"
  end

  def install
    # Workaround for newer Clang
    if DevelopmentTools.clang_build_version >= 1403
      ENV.append_to_cflags "-Wno-implicit-int -Wno-implicit-function-declaration"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
