class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "10f1d123aa0ec066e3256741f1d945b5dfd2c61ca24855556e3a8db93b44d8c5"
  license "Apache-2.0"
  head "https://github.com/square/certstrap.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ebe6504825935cf434e26329c24322134900205abf67e2c77e38115175cd5612"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebe6504825935cf434e26329c24322134900205abf67e2c77e38115175cd5612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebe6504825935cf434e26329c24322134900205abf67e2c77e38115175cd5612"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8c17d6dcaa0ca7d006b888379b7d7545702956154c0e02fa58754f1bc3238665"
    sha256 cellar: :any,                 x86_64_linux:      "71c1333585167539ed1965c85f1fbed64479cc2ed403b2fbaffa9316ca92e6b9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    system bin/"certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
