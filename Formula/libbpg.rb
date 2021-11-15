class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "https://bellard.org/bpg/"
  url "https://bellard.org/bpg/libbpg-0.9.8.tar.gz"
  sha256 "c0788e23bdf1a7d36cb4424ccb2fae4c7789ac94949563c4ad0e2569d3bf0095"

  livecheck do
    url :homepage
    regex(/href=.*?libbpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "0163b78ee46db665ced158c94332742fde7d319cd2ad643ddf7df5512f90bb86"
    sha256 cellar: :any, arm64_big_sur:  "dda2b20e38fdfddf1ece62f781bdcaecdf4858c148d749f534ab9e91b0561171"
    sha256 cellar: :any, monterey:       "e2730a66bf763d4cbe720c4d44189556ba8c97bfcf275fe48480ec91b21fe171"
    sha256 cellar: :any, big_sur:        "b277508b891e51ee15ceae803ac45f946f6d4523ccf22c3d9d6e042c30292386"
    sha256 cellar: :any, catalina:       "559ad6131fbd040428bd8423047f78942aa772726af7d8e9707cad38ab167504"
    sha256 cellar: :any, mojave:         "53691575bb5076233228a76e6657a76af4fcc0ab90f3f54799489e54dbe1a49a"
    sha256 cellar: :any, high_sierra:    "b040d31f8abd45f50f8ba634c97eb81a0ec89ecada773223b2ac362ddd20baff"
    sha256 cellar: :any, sierra:         "77ae8a79d99cae86c42e4eaad0cc240efe98425f58143c940a3525d29d7cb25c"
    sha256 cellar: :any, el_capitan:     "49027f81f126e8bdc24587d43b127815e3a53fafa92b6326c857526678932bef"
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build
  depends_on "jpeg"
  depends_on "libpng"

  def install
    bin.mkpath
    system "make", "install", "prefix=#{prefix}", "CONFIG_APPLE=y"
    pkgshare.install Dir["html/bpgdec*.js"]
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
