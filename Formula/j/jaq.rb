class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "20d53c2c992db9bbe3e4e8636015cdd1429b936fd897cd4b3ff02c3abdd3a9ed"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e65dc181d3b411777b39c4b5427eeb6bc85972a104dcb9c077df99dd4865fd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b031499cdbbb13c191ac66dab548f73626ff5009cf08276640711dbf92d53d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c81286cfd818042dcddad520c3db64fb6baad3a0b4fa06a1f86025d4ef47bfa7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4eb2ded47bf5c0213ce96b78dc8f8364994f7da86be20ac8ebc152ce04f39ec"
    sha256 cellar: :any_skip_relocation, ventura:        "fb1e70d0bcc33e881d7c49739e9f9543e9fb339767a95a8d0d32bbad98e1e71c"
    sha256 cellar: :any_skip_relocation, monterey:       "bd2a912e9e1d3049e03a5b0eb9ced86ec6d81b29c476c42e8e69b54210fbf320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b031c4cfbc2fa77a0abebc71a6e985f085d3a81909e0142e2423f266226f5cd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
