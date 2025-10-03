class E2tools < Formula
  desc "Utilities to read, write, and manipulate files in ext2/3/4 filesystems"
  homepage "https://e2tools.github.io/"
  url "https://github.com/e2tools/e2tools/releases/download/v0.1.2/e2tools-0.1.2.tar.gz"
  sha256 "b19593bbfc85e9c14c0d2bc8525887901c8fe02588c76df60ab843bf0573c4a2"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "956c82862c23ce3476acaf07cca07a5816443e06b8e9ad0f0617d2bc751372c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d4e761cc4311ffbd6f95f98c70bcef07dc394af629fd89226a27897aaaccac3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18e786263cd16c9a8da32596f9114863909e5c50173d568c494be81171894de0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e9ee3814830d3eac0c97e348da1f334929bbbaea3c8b5a2623cf320c470ce8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b4a366c607a8bca05a57a5ae4b086a86370e33f7ee3d51d198b04fdfeffaa20"
    sha256 cellar: :any_skip_relocation, ventura:       "972f0d6881b1fbbccf01f8c65991e7ea7ae277d0d437162c4ff613f9aee73412"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b96b8a916a9ac6332b720e7b2fa1863a4f7939b2d7de3e31ac71da74c7bfb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181c2ef88431d8c4795507d7df121a32eae776ea8e89d1fb0029e00aaa017963"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "e2fsprogs"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system Formula["e2fsprogs"].opt_sbin/"mkfs.ext2", "test.raw", "1024"
    assert_match "lost+found", shell_output("#{bin}/e2ls test.raw")
  end
end
