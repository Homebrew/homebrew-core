class Cherrybomb < Formula
  desc "Tool designed to validate your spec"
  # Original homepage taken over: https://github.com/blst-security/cherrybomb/issues/158
  homepage "https://github.com/blst-security/cherrybomb"
  url "https://github.com/blst-security/cherrybomb/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "1cbea9046f2a6fb7264d82e1695661e93a759d1d536c6d1e742032e4689efe9f"
  license "Apache-2.0"
  head "https://github.com/blst-security/cherrybomb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd0341b2c6a53b6c4e0f42a79e3f1e5bf5a25e2d0c00f317b8fc18254de72951"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3ccf56d17a1d0c267ee4d674bc3106f6693a27ed618768ba85f2390e1d4cfc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a288c2801a7149be6a9b63d3e29115e49446898b457579a9ff46a320ebdd54b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d83874129a6e38b7dcd593342ff466671a40c90d3bf0a48a1a6f9657a15169c9"
    sha256 cellar: :any_skip_relocation, ventura:        "991adbf0625913d6b6b5a24973ccc26155160e3bfc67f86f7b6909bc714f6556"
    sha256 cellar: :any_skip_relocation, monterey:       "790c2d511642f7d35ae2815d1d466067b3ea275f59e9ea5c4f11fcf2ff7c4cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c267814c22eb06a91e7029572694a158b1de67d986e76ebd36973b42f4e840a1"
  end

  # https://github.com/blst-security/cherrybomb/issues/156
  disable! date: "2024-09-16", because: "needs a service that is no longer available"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "homebrew-testconfig" do
      url "https://raw.githubusercontent.com/blst-security/cherrybomb/9e704e1cadd90c8a8a5be4e99e847dd144c68b0a/images/api-with-examples.yaml"
      sha256 "f7dc3d69f69ca11ae3e7e6ee702aff13fee3faca565033058d9fd073a15d9d45"
    end

    testpath.install resource("homebrew-testconfig")
    test_config = testpath/"api-with-examples.yaml"
    output = shell_output("#{bin}/cherrybomb --file=#{test_config} --format json")
    assert_match <<~EOS, output
      Starting Cherrybomb...
      Opening OAS file...
      Reading OAS file...
      Parsing OAS file...
      Running passive scan...
      Running active scan...
      No servers supplied
    EOS

    assert_match version.to_s, shell_output("#{bin}/cherrybomb --version")
  end
end
