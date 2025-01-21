class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.27.1.tar.gz"
  sha256 "3ed3ef0ded8ebcc3f46dc77e24fe4c39141b1b278492289cec8cf2ddcc1a3dc0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30ed473e848e7b58ab1b46f4147e8c2b57d1d03e3021299e71670704af00d711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7a9e532bebdaeb5e378ba48de0164bd47d5ba3d30a1d7d33b9a56387bbb464d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bea7627e96ceed2e5a68d55654db44ffa5e69d3f35439e8402d16d5af73034d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6b19516ae9e85afa1b79f9a87b097cbcdaff3a656b6a25697c45f48769ed663"
    sha256 cellar: :any_skip_relocation, ventura:       "e13182446bb1e274bfc1c9c7c23070bf84e17c2854fe30558ca07f3065210e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e56e8f45ae38b7f25701fdafc1cf888f92d57bf6bc335a55839f4180cfde51b"
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
