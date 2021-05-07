class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Findomain/findomain/archive/4.1.1.tar.gz"
  sha256 "7c513a61218301830f52f65f71cb09b081a859f3cab06fa974f22e9692dd713d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c1df9003d6c98961eb055f0514044dfd41478fdfae671b5bc9007794c8ad086d"
    sha256 cellar: :any_skip_relocation, big_sur:       "256fbc8415d040ea1e52f8c2d7b657668ec0a42887f14089dcb22e5a9cf67803"
    sha256 cellar: :any_skip_relocation, catalina:      "e683ee1142c5ec0dea303084ca991b7b3a9beeca1c9b5e2fb975d2abfea48a2e"
    sha256 cellar: :any_skip_relocation, mojave:        "977fe61e3526d8d57f7904ca07f9e3bc6669b465e270738800995da28b8d9056"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
