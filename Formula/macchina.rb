class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.0.5.tar.gz"
  sha256 "88de2c9718e071dcd9486cf1e7d87d46533100e589d99cd7b18ff43c21a8a053"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c218527daa7c8850acf2abc45ceffe5c4f6c0a876f73367ee398c184377c9c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cd7e1b1120ff85d4a97d44bbddaf22c1aef4414494568a9546c29c62d92e73c"
    sha256 cellar: :any_skip_relocation, monterey:       "e2d019f407e9511cde221718713197fa1f6593b5a53735e54a86d86c68bfabde"
    sha256 cellar: :any_skip_relocation, big_sur:        "26088edb1828246fbcc500cb716a5bb8d08d60d9615c6f7e58fb53fec617ec48"
    sha256 cellar: :any_skip_relocation, catalina:       "8a3e25d1211adbe00e379e503fe4c241342ea6f9e161323ae58c318302549594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a3d69a8346ab012f93c59cb303496ed9325c8deb71d2d01cdb60cbb5b4dd629"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
