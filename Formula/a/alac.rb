class Alac < Formula
  desc "Basic decoder for Apple Lossless Audio Codec files (ALAC)"
  homepage "https://web.archive.org/web/20150319040222/craz.net/programs/itunes/alac.html"
  url "https://web.archive.org/web/20150510210401/craz.net/programs/itunes/files/alac_decoder-0.2.0.tgz"
  sha256 "7f8f978a5619e6dfa03dc140994fd7255008d788af848ba6acf9cfbaa3e4122f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "726f02f4e73857ebafaf7d5d554e6c659b4795ef682aa0ce46c3ee21ffef952c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78ed3a6e07c6093f26c14a5f0a468369a4b2822f456101c0539386e2aeb2c4ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71a71cbbe491b65fd89198aab4168b7ec3d2436896c913a43858c806469a56ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71cd043cec976255c6ae78ad79021dd5ba499b5678e5163e6353f571cae2eb6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d12d2c7b28c99fba529faea181dc91a04ea469e68607f9e3263c082dcb5cde4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f951cde205130f7b732f27ef20ebfc8d1d504805d389c092518c6ca12d0a239"
    sha256 cellar: :any_skip_relocation, ventura:        "5385e4fecc817b09a2be15e6eed1184cd2c4bb1014c6c89d9611a151adb49555"
    sha256 cellar: :any_skip_relocation, monterey:       "c0e143a554186ce5b3c1ad9850c5f65d0248461eeea9f8f02389f74e78989a14"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d6293bbacf08bada008f799f03c6ea3265dd48bd5c81d77d042e4a3bedcf84f"
    sha256 cellar: :any_skip_relocation, catalina:       "0cb8439e4028ea823fb442559c12365bae08499a142ad46d0c89f010f9eb7e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ddb3fb230954f624b068100ddcffa8c288481489f6cd62143beac4cd1e3c45"
  end

  disable! date: "2025-01-10", because: :repo_removed

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    bin.install "alac"
  end

  test do
    sample = test_fixtures("test.m4a")
    assert_equal "file type: mp4a\n", shell_output("#{bin}/alac -t #{sample}", 100)
  end
end
