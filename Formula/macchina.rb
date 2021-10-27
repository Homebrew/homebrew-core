class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v4.0.1.tar.gz"
  sha256 "6b2fc30a2ba8728f6608ec402b9c41f79f4c7753f40d505d4c93ec491671cdb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d8a1954b4e204e3b1f2e048997265ce9d5398d49e1138f6ec9255c62593832b"
    sha256 cellar: :any_skip_relocation, big_sur:       "7cab0d6d4157ed8ccf81e337cec8f0e50a1c844a6d758816d53149c51881e622"
    sha256 cellar: :any_skip_relocation, catalina:      "995b4afaea8d91229dee4ed3de9e084c73a8bb028372fd9ed39da96ada75d806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f1332307f885c14ef4414eafa2ba6da6498010c69c6a3254d68acbc17c25c91"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
