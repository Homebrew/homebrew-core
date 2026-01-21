class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/refs/tags/duti-1.5.4.tar.gz"
  sha256 "3f8f599899a0c3b85549190417e4433502f97e332ce96cd8fa95c0a9adbe56de"
  license :public_domain
  revision 1
  head "https://github.com/moretension/duti.git", branch: "master"

  livecheck do
    url :stable
    regex(/^duti[._-]v?(\d+(?:[.-]\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0682c28b17ef7f44de34a1fd7a6d3eba5b40b8428f78c18462619386bd564cb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "618006e5a13a64c6efbf793329f2b5a2778533103cc00d754deeea03c99cffe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d14d8b6965955bf2ac40e3b894a11285c734875ab1fd672ff6ce8dfeda273a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1854cbacdb3b91f469bb877a3498a45a7dc5035520d0c62e1963929ddc4a3c86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c753d2d0d444ec7ba4b2b1035863da1e77ae5fd5d82eb75fa7a1a41858366663"
    sha256 cellar: :any_skip_relocation, sonoma:         "53e88a9b0bb7c477056523e4c90920e0ba1bf5885a6e573722c0bd904586d23b"
    sha256 cellar: :any_skip_relocation, ventura:        "dce7338c9367ac1b0ea16b2776ab33794d9b262e1abaa6edb3d831aa0b77e93c"
    sha256 cellar: :any_skip_relocation, monterey:       "d1f488fdeb7eb2c5ca0dc3aaaf93bcb382004ff33b87439d0abf017dcb687cb7"
  end

  depends_on "autoconf" => :build
  depends_on :macos

  # Fix compilation on macOS 10.14 Mojave
  patch do
    url "https://github.com/moretension/duti/commit/825b5e6a92770611b000ebdd6e3d3ef8f47f1c47.patch?full_index=1"
    sha256 "0f6013b156b79aa498881f951172bcd1ceac53807c061f95c5252a8d6df2a21a"
  end

  # Fix compilation on macOS >= 10.15
  patch do
    url "https://github.com/moretension/duti/commit/4a1f54faf29af4f125134aef3a47cfe05c7755ff.patch?full_index=1"
    sha256 "7c90efd1606438f419ac2fa668c587f2a63ce20673c600ed0c45046fd8b14ea6"
  end

  # Fix compilation on Monterey
  patch do
    url "https://github.com/moretension/duti/commit/ec195e261f8a48a1a18e262a2b1f0ef26a0bc1ee.patch?full_index=1"
    sha256 "dec21aeea7f31c1a2122a01b44c13539af48840b181a80cecb4653591a9b0f9d"
  end

  # Fix compilation on Ventura
  patch do
    url "https://github.com/moretension/duti/commit/54a1539b23ac764b32679bcada5659fbad483ecc.patch?full_index=1"
    sha256 "055023ce50903ffe9378c68d630a105d317b7efe778c029e3fe23521be89176f"
  end
  patch do
    url "https://github.com/moretension/duti/commit/8d31a2f75fefb61381dc7731cf7ecac9237ee64d.patch?full_index=1"
    sha256 "5987230901e63e619bba85c026201dd00ca3f06016a87516e031eebb6cf0e582"
  end

  def install
    # Patch out the hard limit on macOS version. Don't set `-arch` which is dropped by superenv
    inreplace "aclocal.m4", "AC_MSG_ERROR([${host_os} is not a supported system])", 'macosx_arches=""'

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}",
                          "--with-macosx-deployment-target=#{MacOS.version}",
                          "--with-macosx-sdk=#{MacOS.sdk_path}"
    system "make", "install"
  end

  test do
    assert_match "com.apple.TextEdit", shell_output("#{bin}/duti -l public.text"),
                 "TextEdit not found among the handlers for public.text"
  end
end
