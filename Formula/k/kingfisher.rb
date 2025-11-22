class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "74d37fa48948e33ac1c02aabd9d6390dbce5adf3c04abed497ad7b9a952fdd07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4705dc153aa118f846f3ac90764b1ec661454da99d3a8925f17a606f6c2b6ec1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32012eb0d6eb8774e64997f4583696ef44c1d7b839b22578f45099572100a05a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec37f387efcaac5adf8138a531740596d2a5bb90cf9463b019a7e376b13bfb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "224e46e64a8c22ea85b1c89346539201088b870bfa519c8739624d49e75092f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d163b1d70e8da071b608cd2eb00a31aa9c9ae0ff1301d88c8c77022a98c5ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114f781ce496928ffa5acfdb1da58816ddc3c0c9c7a846b9026d1be9a57fbeaf"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
