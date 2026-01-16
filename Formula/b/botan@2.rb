class BotanAT2 < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.19.5.tar.xz"
  sha256 "dfeea0e0a6f26d6724c4af01da9a7b88487adb2d81ba7c72fcaf52db522c9ad4"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git", branch: "release-2"

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "dd852d6fe3cc65e68fe497d5582c7f3dbaa4c2afced2acea3a9b0f412042bd82"
    sha256 arm64_sequoia: "3b52c4abedf724426066b343384e553b586d7a3d69e437a85839ad1adde27868"
    sha256 arm64_sonoma:  "dc8d1646e46dab1be1f4f53b46f2e111b92610998ec700579c702abe3bee9baf"
    sha256 sonoma:        "534d9389e8a96ed9c171e1c457c931f70783c94515ff502c6fd876c369666f09"
    sha256 arm64_linux:   "faf67b146845389405939b4803884a521fd4210e441b078fea28cdeca78e78ac"
    sha256 x86_64_linux:  "a4d30c4277c84df5b6a0e51b82e049df3bbe90204151143bf68bf214f44cbd86"
  end

  keg_only :versioned_formula

  # Botan2 is currently scheduled to reach end of life at the end of 2024
  # Ref: https://botan.randombit.net/#releases
  deprecate! date: "2024-12-31", because: :unsupported
  disable! date: "2025-12-31", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on "python@3.14"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def python3
    which("python3.14")
  end

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --with-zlib
      --with-bzip2
      --with-sqlite3
    ]

    system python3, "configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
