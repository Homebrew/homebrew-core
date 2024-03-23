class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "ada68589b916ce535cb49a37370b11c2bc9145e444f6e9036a3d74f301de2189"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df9a3aba5106e5a42ad972de1a182e344462ff84ef805c90ccc59fd35d00b424"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36d049322f8205a07a6112bb2559342ec68f3e44e58a978ef6dd7bc82e263468"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9005072c3b8ade326668bbffb1ed3a02b155302f9863fbbc8c1c512f9221fb13"
    sha256 cellar: :any_skip_relocation, sonoma:         "45bcd564f719d9a12abfc9b76208672b3e70e78ead9b9657d794f80a2e931565"
    sha256 cellar: :any_skip_relocation, ventura:        "190bf3ce48f31cdc23c8d89a6988ecab7478374bca2074f7c9931faed20933e3"
    sha256 cellar: :any_skip_relocation, monterey:       "69b6be5da4873ad19510e3bc9c2b669d5fc57a85e713b28443cc17e64011a2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fd191b77ff17574f709b95ef157d9d15bdfcd510c46a91b0c92f64911fa81d9"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp, "15"
  end
end
