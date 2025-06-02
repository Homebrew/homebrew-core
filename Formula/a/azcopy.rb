class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.29.1.tar.gz"
  sha256 "b965c482f19e18d692392b8c622b5fc4041da7eb37c025ae8eb5083791c75006"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2a2baa92616a2e5f0c6a1ee30107633a29ff05fb58f4cf2217a0001d8ff045e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aed5d21ff586e043b7c319a4a7234170ee35775ea573bd457f59d95ca2c58fdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a679e832e080486707c19eaa87283573ca0b3dae40afba621a1c74adc98dabfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b559a91f0425626abbab4532506fb807fc8f979ba67e52c8c8a87952049e06f"
    sha256 cellar: :any_skip_relocation, ventura:       "5ae7763a2891838873117208732371beaae889de30e9a20ad15658efa1882fe7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e78118f8459233c14428d8e3a400f95429f4eb1dc2399cb241fe99f6300dac04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ade0bdd8327ae7edf963b9798674ee3e49d8de95abaae11cbfb3d52625446d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end
