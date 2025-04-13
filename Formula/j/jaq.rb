class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "b8276f6618bd69b2d8feb8d76b927a6debe1bc950742d344643cc4e4d0849009"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "223b129a95196a5ed5e673b234512ae6bcd6899c1b9a8c5a96c12448fc04ac01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cadac6c8878ff6be1a2282ca971464550cdf83bef3f24be6869632ee802d1f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4bc59cc49b110dfcc2d3c961b08573f1e4e587fc6e8969c3432aebe080e04d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8173a7563be39629500009ac5731ade593dc897266e361998f00cf0d102153f"
    sha256 cellar: :any_skip_relocation, ventura:       "fd229c7bfdacd681cb920ad307f514aae748a6d7c509e84115f18964c35da0c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "794691887089716551f42f5c31714c8019e0f0c5ca70f74548bcf73897847388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7043bb1934829923d10e632bbd27b613ea18eb948d3a771784a0a37410bdde76"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
