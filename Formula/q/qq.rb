class Qq < Formula
  desc "A lightweight and flexible command-line JSON processor"
  homepage "https://github.com/jfryy/qq"
  version "0.1.5-alpha"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/JFryy/qq/releases/download/v0.1.5-alpha/qq-v0.1.5-alpha-darwin-amd64.tar.gz"
      sha256 "29e7849a638dc185551e4fce7375f3279ecc1e4e9e5034b4c28994e5a59c6391"
    elsif Hardware::CPU.arm?
      url "https://github.com/JFryy/qq/releases/download/v0.1.5-alpha/qq-v0.1.5-alpha-darwin-arm64.tar.gz"
      sha256 "8e8f1a0ae6d51accda2060290bc8e905c71f73912baaa6480634dbd6b0faad1b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/JFryy/qq/releases/download/v0.1.5-alpha/qq-v0.1.5-alpha-linux-amd64.tar.gz"
      sha256 "5cb1815d1d7cbc88bcf2de921021aaf3b13ef0db782183253682fd87dd5f0b21"
    elsif Hardware::CPU.arm?
      url "https://github.com/JFryy/qq/releases/download/v0.1.5-alpha/qq-v0.1.5-alpha-linux-arm64.tar.gz"
      sha256 "f7edcc9e5407c1ca19978b8be493f528e7a87c9e3a333b976608085c32daa78f"
    end
  end


  def install
    if File.exist?("qq")
      bin.install "qq"
    else
      system "tar", "-xzf", cached_download
      bin.install Dir["qq-*"].first => "qq"
    end
  end

  test do
    (testpath/"test.json").write('{"somekey": "somevalue"}')
    assert_equal "somevalue\n", shell_output("cat test.json | #{bin}/qq .somekey -r").strip
  end
end

