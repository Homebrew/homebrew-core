class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.34.2.tar.gz"
  sha256 "6ebe5d4d8a4776313d0440230a8a8d94a227d09e072d745d592b359b205e719f"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2232907b88574888166b4e8eea136ba9b3d232f9ccb9e895b3078d2a4030d8e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d2f32942df4700298bbaa104adec5e819fa6439955bbfdec409a8ee2813f155"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5016f1af3487500792047c8d21605708c5d1e659600964de2f8ba8c8f1e41bfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a25931b7ff8e2ed2debcd46319b34e585e776009399c45b5f2270cd8b3ff006"
    sha256 cellar: :any,                 x86_64_linux:      "cac24ef6ddeb0f76beaf916f7ce45f250f4dca17c19cdb915d7fcaa8c71bad11"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"azcopy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end
