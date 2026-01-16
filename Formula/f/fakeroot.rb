class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.37.1.2.orig.tar.gz"
  sha256 "959496928c8a676ec8377f665ff6a19a707bfad693325f9cc4a4126642f53224"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "564fd8232d47a45c63da8ef9f7dae69e703529215d4a7c486c5c1e21a7065483"
    sha256 cellar: :any,                 arm64_sequoia: "ab29a59c3530a716bfa3151bed5458ece1bb6b136dd2a316f54f88ff031e1f52"
    sha256 cellar: :any,                 arm64_sonoma:  "1aadc43f4ce3f17a1a609750a139f412205a71b1abc068b06874e83e40fcd7f3"
    sha256 cellar: :any,                 arm64_ventura: "1c11f5d0a36d1d27fb51c32f3989802f4c385796b56959da1472c3a97a42c687"
    sha256 cellar: :any,                 sonoma:        "2c240e8fb51287a6e2304c2aca7dc0e0c0bf7103f72b3f36872abaa23d62c0d0"
    sha256 cellar: :any,                 ventura:       "f67ebe96d1e957f934e9de9cb936671f7fef7780e6e12011828265ec2547ccb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f239b1a7a44fed02417a5230512a0a1f06d3c84bd27aff90db9c9a1a5704dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41acec3bc608043a4a49fcca0008b90bbc45abc655d9b1c13b74577df13297a2"
  end

  # Needed to apply patches below. Remove when no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libcap" => :build
  end

  # https://salsa.debian.org/clint/fakeroot/-/merge_requests/34/
  patch :p1 do
    # Fix for macOS
    url "https://salsa.debian.org/clint/fakeroot/-/merge_requests/34/diffs.diff"
    sha256 "0517ce18112d08cec2268dd2a5d78f033917454c68882665125d9e70c26983fc"
  end

  def install
    system "./bootstrap" # remove when patches are no longer needed

    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end
