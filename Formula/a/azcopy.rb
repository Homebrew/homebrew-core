class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.26.0.tar.gz"
  sha256 "71684c5c1a2c192fb1168ec57a11cd76a3691bb6e1631cab3c1fe61a4dad1bc7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "436cdee5aba0c76dc62808270dda134d96efd73f7217799dd94f845282426e17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4507cc4f4cda254231ce24bb94e9ed8d3c626c7ed44a052e4900f53650bc1b58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6620d5556d773e002a62efd67a7f55265b5c840b9d1fc9e8f218277d69d73d86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b827dc933eb34c45b32265f4f5a066065118c13a8c91dacccd5d61b692e1e015"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7f6ffd568a78d647ca3e826b5e7489e497bb16fab72804eb96d10d5a287a214"
    sha256 cellar: :any_skip_relocation, ventura:        "27df4a08175047637d4223a5eb6c90fe3c4548343b72236bac9656bdf775fd47"
    sha256 cellar: :any_skip_relocation, monterey:       "0b90a79afb8259f9e5b1a47ef2ee5776c4846d4d27085fd9ac5dc719d12275ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb5a640a1656328d550dad84155cfa5ebfdcbfb55041d3799daae2070d0c3a3d"
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
