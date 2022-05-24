class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.10.0.tar.gz"
  sha256 "3bc4ebaf179d72b82277e7130d44c15e2cc646d388124d0acdb2ca5f33e93af6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc3511ced4f06ce883baeb199bc9560940180404a2a028d28e3a1d53e5cbda40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d3f278b41a2fdc6387447d06a820af2160f4809009ba66c67e22d3b45359e06"
    sha256 cellar: :any_skip_relocation, monterey:       "f758d9c3a52d018cdb7419643f723424204d85649b6afd0a805caf81514ea254"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b9a09530c6e0bd26b562bdafc8c41302f59b13d3de4f0bff82404483f7032b1"
    sha256 cellar: :any_skip_relocation, catalina:       "e19230799fbb8021298e8ec752f9b98ff4dc159c2852c16ea81dc0f002c3a57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65ca2b55517c61ff1e71680e33a6657416255ba9d1cf16890f15a7074e982f45"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
