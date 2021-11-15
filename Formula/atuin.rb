class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "0e1cd2104c6fa4cd2d6f30ae9771ed3f22f78a4e0e7b5243e42abb753b792c38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74f8283b43292f8e887a65c593582ca19d6f218029ac70819a4931dbd02b0d0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73a3722439f584b2e0a636f5a87ff08a2a05f3f9d92ed9ec483b82af5069eecc"
    sha256 cellar: :any_skip_relocation, monterey:       "70b718dab99844c63e72fd993c3f0b8ad321adc0a329b9c7d4ee5a1e0f1ca456"
    sha256 cellar: :any_skip_relocation, big_sur:        "b20e08fa6b7025c5a724db1f18a16acdd30950a46eec82f9f1a33852b71a27a9"
    sha256 cellar: :any_skip_relocation, catalina:       "a8cf5ccab9ba3d5782a502e1e2e299e765b2b5e99a6f7adbe723648da80931ee"
    sha256 cellar: :any_skip_relocation, mojave:         "3004a871e9de5e74d1cfb5f1e6aa84a36e5e4826f5fb7da0fe9e8c23fe7d08eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e36422f51fd643bc0f256b5dcfba3b3a2785c58ae8f3c9628cd1a6bfa123adfb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "autoload -U add-zsh-hook", shell_output("atuin init zsh")
    assert shell_output("atuin history list").blank?
  end
end
