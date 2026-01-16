class Lzop < Formula
  desc "File compressor"
  homepage "https://www.lzop.org/"
  url "https://www.lzop.org/download/lzop-1.04.tar.gz"
  sha256 "7e72b62a8a60aff5200a047eea0773a8fb205caf7acbe1774d95147f305a2f41"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.lzop.org/download/"
    regex(/href=.*?lzop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "20091ae058723e28c6d638439220471a1c3862add310adb16aa7cde1e3ad4f1c"
    sha256 cellar: :any,                 arm64_sequoia:  "e29c398855c02fe9980a6365c4285c941988a3baa6fae5357dde1ae2ffed178e"
    sha256 cellar: :any,                 arm64_sonoma:   "3cb9969e29778a627ab2a0c634bc43f30c73ffff9960c51fa27f6eb1945b3ea1"
    sha256 cellar: :any,                 arm64_ventura:  "f797bf586d6db6240f6984be8f115a91f0218e3db024668f926b8a694ff2b57a"
    sha256 cellar: :any,                 arm64_monterey: "32f4ffb33fda5a32802c7a37dcf41eef9b74185e726c6332912dc7d0d524381a"
    sha256 cellar: :any,                 arm64_big_sur:  "32390eb8141791296e84ed7c6a39edb5bb2ded9b04581c301d32a6dfa322db4d"
    sha256 cellar: :any,                 sonoma:         "8b4755580fbfe632a03e98de0944036593c62852c4b9dc60756037594776608d"
    sha256 cellar: :any,                 ventura:        "b521542f32669d0890bd66a3a77cb8517df3f6a619563fb3817be6c7a77acc90"
    sha256 cellar: :any,                 monterey:       "5a74762d3592fc992174fff54cb221db8a4c104f185ac3eff12deda7e97563be"
    sha256 cellar: :any,                 big_sur:        "f04a876a2b69220632fb027546104d9c6cb9ee8bdb1d9f6a2845a054500d8bb7"
    sha256 cellar: :any,                 catalina:       "3aa57a50254d383c0fe0e4d0d0585e1525d50d0cd30f87390d087523348044a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fe1868793eded05a6b15a8015c7859cbd527f183d319469b2dc25981d667e6ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ba7328bdcb1e9789b03851966efb4cd6ccc3feb35cfbc37a364be6fc4c77e7"
  end

  depends_on "lzo"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"test"
    text = "This is Homebrew"
    path.write text

    system bin/"lzop", "test"
    assert_path_exists testpath/"test.lzo"
    rm path

    system bin/"lzop", "-d", "test.lzo"
    assert_equal text, path.read
  end
end
