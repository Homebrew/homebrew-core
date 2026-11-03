class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "038db54e006d0e2525632fc32358ba7394a9c8df0503236b04d9bc3bd1064f64"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ef8dd3158e7b63058d7be95c03e81f1dcc62cd768aefc5da7eb6a9ff9e02156"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ef8dd3158e7b63058d7be95c03e81f1dcc62cd768aefc5da7eb6a9ff9e02156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ef8dd3158e7b63058d7be95c03e81f1dcc62cd768aefc5da7eb6a9ff9e02156"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d82b57a4cb9dd71df3f2d4e402f585615bdbc58db62b72e0dc3f5547937fd51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "26f636932dcdb2c45c6a49e4ed849a22a147ce82df7dbbfe4479c873fce905c7"
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
