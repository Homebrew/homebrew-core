class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v0.7.3.tar.gz"
  sha256 "3d770b2a06f7ef2c7163809dc24c3d214b228d985ac70516f59234a5581febb0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81795c02dec7c9dacfb7f13e19d78ecad1ad136d85c22906a9e6cecbba6e4ec4"
    sha256 cellar: :any_skip_relocation, big_sur:       "6c28004ad4a39a4197528f351946d38224559e8a332eec5530c8ae7e4d3c7056"
    sha256 cellar: :any_skip_relocation, catalina:      "f77b37d8ffd61ea1bb485a494f131ac4a49bfd8fa644085ebffb7b5cb8beecf0"
    sha256 cellar: :any_skip_relocation, mojave:        "99acae50b39051e9f7bf62b1ae9bc98a093a22d54ad074171673424192b68395"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
