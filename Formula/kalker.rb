class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/v2.0.3.tar.gz"
  sha256 "d2904b5b537a2ec31570f83ac36da0fcf95b0b2957594edf8f07881a067bf8c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d342da2b8076cc114c72febbd3dd74df3de208776d71ed2825331f87faf2db9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c1b870e929e71dd17dc21ea8fcb50e696048ad73b3a1a0af15ac3d77f497ce9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46f1e6d7298380a52adb938edc323bcc9b769d911e959e54907e70e19c95dbfd"
    sha256 cellar: :any_skip_relocation, ventura:        "cf1791824b8379c031787f6607b312b5e64ff661f484f989e19ab23e5f6d18b5"
    sha256 cellar: :any_skip_relocation, monterey:       "00e7ccd66833dcdc873f8ba1e541f0046dca54880e953c5127ecb4f4c6e8d9ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "cadaef2ed7a99fee80c7477ddad17fbeda0438231a6a71a412bf3beeca451173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1a2bf4f7f4ac84ee2bff41f7bf89bdb1ca759f62194d306412253582e6d5f7d"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp, "15"
  end
end
