class Nping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https://github.com/hanshuaikang/Nping"
  url "https://github.com/hanshuaikang/Nping/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "5d445cb65d0f048df39cb18a8cec94168940c98a59cea5673d15a26f0de87201"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9136f7e33a520e7001a8f10bb737607656bf2cb47537838a8234e16043148c7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d560c89b12da7d7541177367187a8fcaad60dafa9e14cca72aead2fe1cec1a2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d788ebf7d9e3efb94d23b6f9b3f10d90c611dc31597e30d93065a31135fa0737"
    sha256 cellar: :any_skip_relocation, sonoma:        "72043c6c4d34707cdd0018b8f17a84b7ec0caf116e175a48a4ba5ec1a61071d0"
    sha256 cellar: :any_skip_relocation, ventura:       "152e01c63936a65b841d904169ebe665a0f9b2cec7b82dfd296d7dcf4a76005c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d38e12290fb9ce58413203564345087714c5fa9f0ce5c3eb762184ba1af96a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fe4781035df88fe41a4399fffdf716c3e5b3868170c1ebd901c9620ca1d672d"
  end

  depends_on "rust" => :build

  conflicts_with "nmap", because: "both install `nping` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "nping v#{version}", shell_output("#{bin}/nping --version")

    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"nping", "--count", "2", "brew.sh"
  end
end
