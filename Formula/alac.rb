class Alac < Formula
  desc "Basic decoder for Apple Lossless Audio Codec files (ALAC)"
  homepage "https://web.archive.org/web/20150319040222/craz.net/programs/itunes/alac.html"
  url "https://web.archive.org/web/20150510210401/craz.net/programs/itunes/files/alac_decoder-0.2.0.tgz"
  sha256 "7f8f978a5619e6dfa03dc140994fd7255008d788af848ba6acf9cfbaa3e4122f"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71cd043cec976255c6ae78ad79021dd5ba499b5678e5163e6353f571cae2eb6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d12d2c7b28c99fba529faea181dc91a04ea469e68607f9e3263c082dcb5cde4"
    sha256 cellar: :any_skip_relocation, monterey:       "c0e143a554186ce5b3c1ad9850c5f65d0248461eeea9f8f02389f74e78989a14"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d6293bbacf08bada008f799f03c6ea3265dd48bd5c81d77d042e4a3bedcf84f"
    sha256 cellar: :any_skip_relocation, catalina:       "0cb8439e4028ea823fb442559c12365bae08499a142ad46d0c89f010f9eb7e5d"
    sha256 cellar: :any_skip_relocation, mojave:         "ffc34867982b3a942be2bfa1c9a561bc85270871b029c45a16fc11ffae899603"
    sha256 cellar: :any_skip_relocation, high_sierra:    "17bffb09018ddf7d96258b99860d75fb9a203037a356cb0f2e4c6c4520cdc4c3"
    sha256 cellar: :any_skip_relocation, sierra:         "3c833c71834ea65498c761d4fe444a26e97e107433de526ab55ad1fb0d36a2ba"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4cb85c125553c6c2a49576790c5be5e0b89096569131df3b8576f3499e65ef5a"
    sha256 cellar: :any_skip_relocation, yosemite:       "a3a54a254a147f3a1173870bdd2e9399043b3e506d8c04383f99cf3ce67a4fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ddb3fb230954f624b068100ddcffa8c288481489f6cd62143beac4cd1e3c45"
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    bin.install "alac"
  end

  test do
    sample = test_fixtures("test.m4a")
    assert_equal "file type: mp4a\n", shell_output("#{bin}/alac -t #{sample}", 100)
  end
end
