class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/cointop-sh/cointop/archive/refs/tags/v1.6.10.tar.gz"
  sha256 "18da0d25288deec7156ddd1d6923960968ab4adcdc917f85726b97d555d9b1b7"
  license "Apache-2.0"
  head "https://github.com/cointop-sh/cointop.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "748c6976d944ab4c0d683821fa1eded84813b7072c533fc88e8d3fc34a290b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b47869b3c333a5ac0f97d68d6a6af6b2e9c2242f6bbc15409d223199f5821cce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1387a159944a0ae1559545b5bb501dcca6604d558852c6d8da0520758db8e6f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6439f989983c4513b8d0744b6e05d56e7c79a7ca2e25ef6fa4ed0547c7aae90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d21f1ec4932e705f02abb72f4df4e2131701ec33468669f5c237b27b550c56a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f4382e37410132227a7df21cab8aa4b189a0e58a3e30f09f38b0f728295db7e"
    sha256 cellar: :any_skip_relocation, ventura:        "bd19ac7d0982181775335fa3bffba8a68a31154df656ee2b14f69ff1137aca59"
    sha256 cellar: :any_skip_relocation, monterey:       "e2120a9df18b3d4cb3bca96477d1a4849ed9bdf3b0310958b43d555f49bcaa5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b320c63a712d387811bc0732362b0e0e25799fd3d28ff775272a459755d7efa7"
    sha256 cellar: :any_skip_relocation, catalina:       "6d5851a8c19e542358d91a02a0a6c9dbac8571e50865403026620b24890f3ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ac984c14974abe0006d84d1e802a2eddb376e2603f88fd42b60decab2a8c2ad"
  end

  deprecate! date: "2024-02-25", because: :repo_archived
  disable! date: "2025-02-26", because: :repo_archived

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/cointop-sh/cointop/cointop.version=#{version}")

    generate_completions_from_executable(bin/"cointop", "completion")
  end

  test do
    system bin/"cointop", "test"
  end
end
