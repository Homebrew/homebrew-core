class Akku < Formula
  desc "Package manager for Scheme"
  homepage "https://akkuscm.org/"
  url "https://gitlab.com/akkuscm/akku/uploads/819fd1f988c6af5e7df0dfa70aa3d3fe/akku-1.1.0.tar.gz"
  sha256 "12decdc8a2caba0f67dfcd57b65e4643037757e86da576408d41a5c487552c08"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/akkuscm/akku.git", branch: "master"

  livecheck do
    url "https://gitlab.com/api/v4/projects/6808260/releases"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.map { |item| item["tag_name"]&.[](regex, 1) }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "525ddcc47892beb6922d45852f96cd4cdb3b7981605acf5d415216a2e728b44e"
    sha256 arm64_sequoia:  "0f13478e5f6f3b41e6e75beac905b2aaae1df9d9a1eb7d600bf0f6bf70b076f0"
    sha256 arm64_sonoma:   "565a1f1bba15ccfbe640704c86b1752a03fe8935b86fefe5c02f946d51cf6b0a"
    sha256 arm64_ventura:  "dac9e5f8e17d8b88899acb8fcd0678e863c028737aa921c07ad982804c3ab656"
    sha256 arm64_monterey: "a0a5fc11cd13c9ebb25ad4d8e46c607a67b061852e4d3ef17ec1ace4758d8962"
    sha256 arm64_big_sur:  "4bdac89c45742a59172e3e2653ef27dd1234d0c8a4483eccdb978e4ece15222c"
    sha256 sonoma:         "ca9a81689b78a05f3d8679810825438d3617e3195c4a1c4831219949ec78b73e"
    sha256 ventura:        "f77236380b87ec9fac32323c1aa339e8d2aa90c5613ba90bf5b33b449a6ba601"
    sha256 monterey:       "a1de5fe0cd475fcdd4b5c91762dfbeb0d681fa59bcba9472972dbec356b517d6"
    sha256 big_sur:        "85a186c3e7502ceafc16741ade1c34601e713538f2dc080c6c0a01cfc0e109f2"
    sha256 arm64_linux:    "e01b75b5ae763d756faf1c9e6ac2c308a99d0d639c324726b92b46cbc2bbc7e5"
    sha256 x86_64_linux:   "23a1841305dd2e17051dc12c0e0c10e17420c432a0fca409ece365558a5cce4f"
  end

  depends_on "pkgconf" => :build
  depends_on "guile"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"akku", "init", "brewtest"
    assert_path_exists testpath/"brewtest/brewtest.sls"
    assert_match "akku-package (\"brewtest\"", (testpath/"brewtest/Akku.manifest").read
    assert_match "Akku.scm #{version}", shell_output("#{bin}/akku --help 2>&1")
  end
end
