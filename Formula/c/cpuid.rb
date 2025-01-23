class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.2.9.tar.gz"
  sha256 "d0aa17338c623af41fe17bb542ebaac5313a56c5f0a400577ee89319d054b4ca"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f95188e40b7e55fc5451537908b22ccb1d6ad6c092834a69c2a8d99de6f53fe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95188e40b7e55fc5451537908b22ccb1d6ad6c092834a69c2a8d99de6f53fe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f95188e40b7e55fc5451537908b22ccb1d6ad6c092834a69c2a8d99de6f53fe7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1860157d6df98e8353bb72b0201c0a044a4c7766e6d8e0d764abe1e49bfc749f"
    sha256 cellar: :any_skip_relocation, ventura:       "1860157d6df98e8353bb72b0201c0a044a4c7766e6d8e0d764abe1e49bfc749f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cb7c366b4d4e397d0a7c0f76ce0319756403b89cc1302a27eae587f201b5646"
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
