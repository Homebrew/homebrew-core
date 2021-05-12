class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.1.3.tar.gz"
  sha256 "8f4598a2cd8aba9cd8da12f877abe77a5fb51beb9359d06aff1c61a907733e13"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "adb7b102a4871781f1263ebf6fdbe524870ee13fbc8e9837596d98da8f7673c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f23e2f46a19edc9031ecfe98afb4a1a116a1e2e8581a21b3001fbbb17adf136"
    sha256 cellar: :any_skip_relocation, catalina:      "18f861108895fc0db499f620848d2fa160c3c5d0d9fd80062ad92dd11d02d79d"
    sha256 cellar: :any_skip_relocation, mojave:        "7614af7abba458717bfada234830cd98eae89295ad135d88aca0fef4e5a44df7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
