class Exiftags < Formula
  desc "Utility to read EXIF tags from a digital camera JPEG file"
  homepage "https://johnst.org/sw/exiftags/"
  url "https://johnst.org/sw/exiftags/exiftags-1.01.tar.gz"
  sha256 "d95744de5f609f1562045f1c2aae610e8f694a4c9042897a51a22f0f0d7591a4"
  license "BSD-4-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?exiftags[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b4c31682830f7f18a47fcaa2c2c61d28e1e36cca0ab480d41ffffde7731f7b06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "43f7d6a7bd08e653cfde12d0f3cdcdb371b27bb4912a8f2bcda42120da960cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "499981c69ffb64e8bdc63a1b43a07884fa62a11034112483f00eca053836a031"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c0fa5c7f7ec7c138c3601aa24c6539210b2e8aa06694c2caa7edb936dbad92d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "066860c554be69f80330da1152b1d4ef3c6ff177dbb73a20367dbd5598ff0029"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2229163e3493c0fae8cf83479f5c5258b926437b353038cd738d7f7d50fc20f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab4c192e4d932cac9aba2b50781e4c8a44678398e4e99b507dd458fafd472b95"
    sha256 cellar: :any_skip_relocation, ventura:        "dbc075e01b52cabb93e00ab84498cbcb0e32e1597259f28630fed2524f8be6eb"
    sha256 cellar: :any_skip_relocation, monterey:       "d6dddffe9628d46253e6ec7af11a16cb60c2983c475210f718f1f69d030c99e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6f10871b2577320dd9c219faa1e1b31fac8a311cde68810d233aaafa79a5a08"
    sha256 cellar: :any_skip_relocation, catalina:       "f4236ab5e0f9f3710e32ca5a6932f47d0b11c232c6f84bfc4ac4694fb26ac832"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "548670490adcadbf70e7efc3e1fa7193a908abc34e75593bd0bcb52294120f44"
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
