class PlzCli < Formula
  desc "Copilot for your terminal"
  homepage "https://github.com/m1guelpf/plz-cli"
  url "https://github.com/m1guelpf/plz-cli/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "84a8835f091b305d21f52c36a19b4f4264ee72348f576ea2dd5a4c383f84acce"
  license "MIT"
  head "https://github.com/m1guelpf/plz-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "712daed5162a08666a528b6ac4a39ee38d823ad901f4ee99e7a4cf84c8347a44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e21593300690424d358f6a89b269901fc0b0d0d0a280fd26cf946aea957ab5e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11f8a1dff87667615edf74528f56ba9d0154a82bfee8cf6f6d4bc48ebe6eae27"
    sha256 cellar: :any_skip_relocation, ventura:        "98cdd319c98ab3f97188ea676c5dbfb6e25688421169cca9bb11d55e0d29a648"
    sha256 cellar: :any_skip_relocation, monterey:       "9b5e3b8d1338d44c175939695d27d071d46c59016f99428bf9125764344aefe4"
    sha256 cellar: :any_skip_relocation, big_sur:        "40a9e0bb5b19683781d3e192981fd718fc8053b701df5e7a9baa972919387d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "418a5123b2bee4b8ab221598b5eedbfa3c94d48caad848617f36e43f28ae3db8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["OPENAI_API_KEY"] = "sk-XXXXXXXX"
    assert_match "API error", shell_output("#{bin}/plz brewtest", 1)
  end
end
