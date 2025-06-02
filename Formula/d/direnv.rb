class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "edb89ca67ef46a792d4e20177dae9dbd229e26dcbcfb17baa9645c1ff7cc47b0"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "8a1b7af4d31aa491936580dbd610fb42ff7dadfbcf4c17dde7cba96b9455fae7"
    sha256 arm64_sonoma:  "3ff6d45f5f77b9a52940e919e688b0fbe47a53aa76c6716619dc29f85bc2c149"
    sha256 arm64_ventura: "960dc9caf8b3724bf2da2f08b44d4b7feedbe486081cc1958cfe1c03f8439198"
    sha256 sonoma:        "b9ad0b7bd6d72a57b52a78f481d53f6df54c589c913c4c8837b984719048de7a"
    sha256 ventura:       "70d7017e51a8f523ebba0650a109e269cd8840366548ff321903a9ccea098cb6"
    sha256 x86_64_linux:  "81c866237f98a187bd7bbeea7b96e1c05f85aa858142bb264b9b9e6ca33ec9c8"
  end

  depends_on "go" => :build
  depends_on "bash"

  def install
    system "make", "install", "PREFIX=#{prefix}", "BASH_PATH=#{Formula["bash"].opt_bin}/bash"
  end

  test do
    system bin/"direnv", "status"
  end
end
