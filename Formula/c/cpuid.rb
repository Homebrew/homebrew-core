class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "84646f95812586763e010f46c7cf2d9aee6774724ff75f34e0ea4a25aa51a437"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05c690130690c2fbb988e37bd5e40d23f16115030997c9c4605dbf07835784e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05c690130690c2fbb988e37bd5e40d23f16115030997c9c4605dbf07835784e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c690130690c2fbb988e37bd5e40d23f16115030997c9c4605dbf07835784e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6c2e4ff86d85de9e5bab22dafa4c5d81f81fc40c749833dcc98a7593d00f9c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cdee2cb73e8210cf5e9d7341afc0844c505da349e3a6d5a9421fc4becf7a439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef010ef8db4bef315e0d82f6c42e4bc59ac0f6e5a6ff7330f19baea34a39bf9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpuid"
  end

  test do
    json = shell_output("#{bin}/cpuid -json")
    assert_match "BrandName", json
    assert_match "VendorID", json
    assert_match "VendorString", json
  end
end
