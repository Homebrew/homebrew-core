class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.6.22.tar.gz"
  sha256 "4bb29c35ba7bb9743ccfe5c44348cdf27da582884afe0396a0ce2dcd011ada30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ea3bd2080795f8edfc8a3a2dc37fbef46e1025e895c9ee2c81fe9eb3f875174"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74ef6a4dd2cc8d7041b3b3213b0464c872a186d7b54fc265d07242fe372f4004"
    sha256 cellar: :any_skip_relocation, monterey:       "648a4ecf4109b7498f523b60ca6c81989acdc2af900b3c995308f4af4a9fde20"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebf246ce3473cc1960a980a4a141db4bbf6a6c492a0884c7cc27657c1a1249f9"
    sha256 cellar: :any_skip_relocation, catalina:       "b35d2fa0a21a6b2bc6fe62f394fee75a78b2fc13498e6b30b148625cb2fa7d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74c7b6536686e6a597d1c1cab0ce8f2ce9ac1f634df349dbefa31c2dd0f6e5d9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
