class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "2ebe64c72afbcdfc761efc16c8ad625a142131465f58921f567f2e93c9f72e13"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13fbd13d92f676f52d9b95bebcf326271ce69b4c0248327cf22298592e9e5aba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13fbd13d92f676f52d9b95bebcf326271ce69b4c0248327cf22298592e9e5aba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13fbd13d92f676f52d9b95bebcf326271ce69b4c0248327cf22298592e9e5aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2b933c5ffbce708b98cb38aa8c4d469aa93c18fe57c116939201b7953be15c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1103e43c522c279f3b467341558787ef19373b7a48ff2723cf8d073d180176c3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cpuid"
  end

  test do
    json = shell_output("#{bin}/cpuid -json")
    assert_match "BrandName", json
    assert_match "VendorID", json
    assert_match "VendorString", json
  end
end
