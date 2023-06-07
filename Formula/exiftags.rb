class Exiftags < Formula
  desc "Utility to read EXIF tags from a digital camera JPEG file"
  homepage "https://johnst.org/sw/exiftags/"
  url "https://johnst.org/sw/exiftags/exiftags-1.01.tar.gz"
  sha256 "d95744de5f609f1562045f1c2aae610e8f694a4c9042897a51a22f0f0d7591a4"

  livecheck do
    url :homepage
    regex(/href=.*?exiftags[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c0fa5c7f7ec7c138c3601aa24c6539210b2e8aa06694c2caa7edb936dbad92d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "066860c554be69f80330da1152b1d4ef3c6ff177dbb73a20367dbd5598ff0029"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2229163e3493c0fae8cf83479f5c5258b926437b353038cd738d7f7d50fc20f9"
    sha256 cellar: :any_skip_relocation, ventura:        "dbc075e01b52cabb93e00ab84498cbcb0e32e1597259f28630fed2524f8be6eb"
    sha256 cellar: :any_skip_relocation, monterey:       "d6dddffe9628d46253e6ec7af11a16cb60c2983c475210f718f1f69d030c99e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6f10871b2577320dd9c219faa1e1b31fac8a311cde68810d233aaafa79a5a08"
    sha256 cellar: :any_skip_relocation, catalina:       "f4236ab5e0f9f3710e32ca5a6932f47d0b11c232c6f84bfc4ac4694fb26ac832"
    sha256 cellar: :any_skip_relocation, mojave:         "8287c22dcfeaaf6a28a4036ce26c4a1febfe8a3bc01a1d7320b667d56d0b2e43"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1ba9c96bf8630f50faf8bb5045bace46c5c24962d439a496a6f606b7bc886a08"
    sha256 cellar: :any_skip_relocation, sierra:         "7aaa2a8e78b03e4f842c84a46ce7fb5ed8ff1a956ababde1f26bc716431a67e0"
    sha256 cellar: :any_skip_relocation, el_capitan:     "47d75e83f89d0db4a54d779d9c9820fbb788c102738824e86b83a441d9a60af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb2331fd48ad529d9fe2c1cda8f11370d2982afbcebe6403ed18333d6a86416"
  end

  def install
    bin.mkpath
    man1.mkpath
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "couldn't find Exif data",
                 shell_output("#{bin}/exiftags #{test_image} 2>&1", 1)
  end
end
