class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/v0.15.1.tar.gz"
  sha256 "ea20516da0983070a887ea181f788504e0915020d3da5d9c112e2e12c8c7dc32"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e6bacf0a7e2c259837cc48cbcfd0a4cfcf243790c7c9c6794ffa4ed369c0072c"
    sha256 cellar: :any_skip_relocation, big_sur:       "48d278bb24ce6469ab4b1080795d34738b4ba4912e5564621da62fe6c8f6fa18"
    sha256 cellar: :any_skip_relocation, catalina:      "710b09a41e0f9b46c9c05a8368ab4dbca86343445728d323b31a02d603d5ffb0"
    sha256 cellar: :any_skip_relocation, mojave:        "65ab51a5a3664d8864ff168f4ba281bed66edb7c80474dec169405ffc51171cf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"clarinet", "new", "test-project"
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
