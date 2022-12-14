class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "bd65882ac77c56cc4a8af5c7c72aa10818ae0b53b9a6928c6d02294e23798344"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

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
