class Lrzip < Formula
  desc "Compression program with a very high compression ratio"
  homepage "https://github.com/ckolivas/lrzip"
  url "https://github.com/ckolivas/lrzip/releases/download/v0.7.2/lrzip-0.7.2.tar.xz"
  sha256 "2954d650633cbb3134ca023f50990cd460c891e1d0518824850213a84c9ce1a3"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/ckolivas/lrzip.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1336ea32214e5a828317a17e16f4b98ffe1d23f972f423a69211f10c8ea4fada"
    sha256 cellar: :any, arm64_sequoia: "66d0f33698a2cd55962dea6d0ae07f99b8de094022bad88a8d19696e05bd54ed"
    sha256 cellar: :any, arm64_sonoma:  "49e4756d544aaa1a35d61de30b92980a021328d32c1bc730ff2040f4faf340b2"
    sha256 cellar: :any, sonoma:        "24c58b9098ba037f001207d583e6c46111c2af83eff7910d3b1d88d37ebca5f2"
    sha256 cellar: :any, arm64_linux:   "8594e4c49f76c7c77fd45fbdcc317d097eb5a15a1e4a0f92cc1207c82162ffc5"
    sha256 cellar: :any, x86_64_linux:  "b2bb00a3676f64e2807dbe90210e58ed47d2c32f7592d2e3349f64e993d531b9"
  end

  depends_on "lz4"
  depends_on "lzo"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "lrzsz", because: "both install `lrz` binaries"

  def install
    system "./configure", *std_configure_args
    system "make", "SHELL=bash"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lrz
    system bin/"lrzip", "-o", "#{path}.lrz", path
    path.unlink

    # decompress: data.txt.lrz -> data.txt
    system bin/"lrzip", "-d", "#{path}.lrz"
    assert_equal original_contents, path.read
  end
end
