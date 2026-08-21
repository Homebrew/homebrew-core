class Caesiumclt < Formula
  desc "Fast and efficient lossy and/or lossless image compression tool"
  homepage "https://github.com/Lymphatus/caesium-clt"
  url "https://github.com/Lymphatus/caesium-clt/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "3dc4bc062536fcaa368d044aea873afd695feeabd9310d6118a7d45b2f0ad52e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c50f3e42e3527ceb4377b11b6e6db2540459772e1c40e0f6792d33021e51cdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c6e28ace8e0d1f131276ad61ce8d85db62c11f87763d793751f3c2d72da9a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "616830712d3b4408ed2a31b6de2a7df99704386ffe7417f9e92e4ea9e3937f9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "174a134a4e548157966ab5b453b8e666e3ea66bddab0564c741bcff68d50de39"
    sha256 cellar: :any,                 arm64_linux:   "dcdd5f0d49a76163fa4d40010b1fad16745d97f48dac751df1d2a1b3db1309b4"
    sha256 cellar: :any,                 x86_64_linux:  "2e01d5481434637c05935155d543d60118cb13cd5d8be4f96da832c76ec97a51"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"caesiumclt", "--lossless", "-Q", "--suffix", "_t", "--output", testpath, test_fixtures("test.jpg")
    assert_path_exists testpath/"test_t.jpg"
    system bin/"caesiumclt", "-q", "80", "-Q", "--suffix", "_b", "--output", testpath, test_fixtures("test.jpg")
    assert_path_exists testpath/"test_b.jpg"
  end
end
