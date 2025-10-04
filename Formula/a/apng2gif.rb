class Apng2gif < Formula
  desc "Convert APNG animations into animated GIF format"
  homepage "https://apng2gif.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/apng2gif/1.8/apng2gif-1.8-src.zip"
  sha256 "9a07e386017dc696573cd7bc7b46b2575c06da0bc68c3c4f1c24a4b39cdedd4d"
  license all_of: ["libpng-2.0", "Zlib"]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "ed45a01466de66b866f9b894a9a12299c51b2f663facd8af4d262429b9507ada"
    sha256 cellar: :any,                 arm64_sequoia:  "0f86e3508b3328f66e3ada01096160126c5ef87912d0a6a187a0200293d0d93f"
    sha256 cellar: :any,                 arm64_sonoma:   "20bcd262d61b96408beb4146b7adc55fa3f18d5a9170949670245bc9e0128f58"
    sha256 cellar: :any,                 arm64_ventura:  "96885dd78971006a1a9c2110cf491436d16cb705fd29c67a8506c06c41cf867c"
    sha256 cellar: :any,                 arm64_monterey: "06feb5f45bd0926a23bcda94caf5af7eb1f29166b71853ea3c9136c74c63d000"
    sha256 cellar: :any,                 arm64_big_sur:  "b11d6a2f6d1eba7587c8541f65440b027596ae8b3b60ea23e080a237d0b215a3"
    sha256 cellar: :any,                 sonoma:         "d8ac4e2fb2ec309f7eb0b5fb0ad011166cb37884b2090fbbf839f78277436ec4"
    sha256 cellar: :any,                 ventura:        "f67f54a6e9f79ca11e7d1c0f5b9d4fbbf43ed6f4b0045875287ad4dafb5df70d"
    sha256 cellar: :any,                 monterey:       "58b5118280140555684d30a9682450f95ddcbbb7f2f03d6a354da850b3f432db"
    sha256 cellar: :any,                 big_sur:        "8c541ad0b322c10bacc60230d91daf242f3b7ebb8e5deb72860fe2dc1b8cb551"
    sha256 cellar: :any,                 catalina:       "e602a9876003067007cdd579101e1fafa937e7a2ca328a0406e872d6be4f5705"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e05a9e7698a6e549570520d9c2edbd687265df5b5a7fc5d806d8c525b178fd6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f98dfacc9457ddd5742ff27448fdd3b51dbd1445a586447327404bcb0028b72a"
  end

  depends_on "libpng"

  def install
    system "make"
    bin.install "apng2gif"
  end

  test do
    cp test_fixtures("test.png"), testpath/"test.png"
    system bin/"apng2gif", testpath/"test.png"
    assert_path_exists testpath/"test.gif", "Failed to create test.gif"
  end
end
