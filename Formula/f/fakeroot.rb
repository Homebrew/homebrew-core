class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.37.orig.tar.gz"
  sha256 "9831cc912bc1da6dadac15699c5a07a82c00d6f0dd5c15ec02e20908dd527d3a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "647e9457772bddc612f27a723e14300d93e3c2f3667d5ee2bc793b0d5f98d4df"
    sha256 cellar: :any,                 arm64_sonoma:  "12e511b9948587b2de142a2eee91a412dc616e67a1afb817e7aa35ada4b6cc16"
    sha256 cellar: :any,                 arm64_ventura: "4a0364a4e98965315fc566e1265e8a77c0c32713d306ed79bb9e4806b367ab7e"
    sha256 cellar: :any,                 sonoma:        "cf5a7b35b7d32e6ee241d55f6cf6602c82c05742dde424104b0cf36fd108dc89"
    sha256 cellar: :any,                 ventura:       "e6a7093ff9f65c47b96437b5d737a2882876d367630ec7a804660904f9694dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd65f258b27db728d98c1674fde4f43f753b53c7afaa7074ffa9881b13f4da5f"
  end

  # Needed to apply patches below. Remove when no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libcap" => :build
  end

  # https://salsa.debian.org/clint/fakeroot/-/merge_requests/17
  patch :p0 do
    # The MR has a typo, so we use MacPorts' version.
    url "https://raw.githubusercontent.com/macports/macports-ports/0ffd857cab7b021f9dbf2cbc876d8025b6aefeff/sysutils/fakeroot/files/patch-message.h.diff"
    sha256 "6540eef1c31ffb4ed636c1f4750ee668d2effdfe308d975d835aa518731c72dc"
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
