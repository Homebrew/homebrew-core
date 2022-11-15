class MacosTermSize < Formula
  desc "Get the terminal window size on macOS"
  homepage "https://github.com/sindresorhus/macos-term-size"
  url "https://github.com/sindresorhus/macos-term-size/archive/v1.0.0.tar.gz"
  sha256 "5ec39d49a461e4495f20660609276b0630ef245bf8eb80c8447c090a5fefda3c"
  license "MIT"
  head "https://github.com/sindresorhus/macos-term-size.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bc40ca23b802dbca1e7895f476a61f62cabbd2ee4b149028cf7e9a57b1ee1cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f44cab0d2907e1fe48658f15eb8719e2df21e904df6b00ccd69b3dda4be38752"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d921643767d4c489f435e467e0f5bd9d50a1f8a93ccf2be116eb6987af36d86"
    sha256 cellar: :any_skip_relocation, ventura:        "34b5f31903d75d3524c533e43a4edcdd5501d0fb93ea7c09e0ea3e7b4dc27f13"
    sha256 cellar: :any_skip_relocation, monterey:       "c9171245cbf3ba0231147e961ae6cb2e4d8e13a8c7abc64bad1a0e57a4274efb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a19d9785c6b4d8ccf231187d4042174a0c70ce7cb81733880c01d5a24329d31d"
    sha256 cellar: :any_skip_relocation, catalina:       "c5134e35cdce944ea758f7d9a0b3275924bc1b323c42685835afea6646f07d85"
    sha256 cellar: :any_skip_relocation, mojave:         "37ad145efc846c8cad42a969a4ccfb74c8f18462f776414c852346f4c6c37c07"
  end

  depends_on :macos

  def install
    # https://github.com/sindresorhus/macos-term-size/blob/main/build#L6
    system ENV.cc, "-std=c99", "term-size.c", "-o", "term-size"
    bin.install "term-size"
  end

  test do
    require "pty"
    out, = PTY.spawn(bin/"term-size")
    assert_match(/\d+\s+\d+/, out.read.chomp)
  end
end
