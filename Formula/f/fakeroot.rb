class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.37.2.orig.tar.gz"
  sha256 "0eea60fbe89771b88fcf415c8f2f0a6ccfe9edebbcf3ba5dc0212718d98884db"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb496ad0f12203de3fb0ba287620f65883f1e90cf2f67dc53021a1dfdd448430"
    sha256 cellar: :any,                 arm64_sequoia: "bff583cc0931e9a01bf287230b319bd68d8f8083881ca9fadeba02f2b61b45ee"
    sha256 cellar: :any,                 arm64_sonoma:  "b463fc4605df2dd647baea44571170e058a9662f0df507ca6e2ed1a0b6e68593"
    sha256 cellar: :any,                 sonoma:        "38c3bbe68895d203e84372ab3f1f5658fa160d8edc241e3ab01d19b37cd773ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63d8636c69b2bad7bda249e7273d95079ea10ea6ccfadc654ba9282d114a9f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c24ea0f7754e65c3243a293aff65150a855485b760f42e7a230de0c4bf508681"
  end

  on_linux do
    depends_on "libcap" => :build
  end

  def install
    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end
