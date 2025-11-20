class Lzsa < Formula
  desc "Lossless packer that is optimized for fast decompression on 8-bit micros"
  homepage "https://github.com/emmanuel-marty/lzsa"
  url "https://github.com/emmanuel-marty/lzsa/archive/refs/tags/1.4.1.tar.gz"
  sha256 "c65ca1e6a43696f4ca5edc2c98229fba1044806bd21bc2a8ce4b867dc9cfc45c"
  license all_of: ["Zlib", "CC0-1.0"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c4f00c8b228bba2a577616661e13d5d710dea4afd8f5149fe9382b8040b09c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7eaaf3697f803f186818868d7559275d20ea9ec91226108fe89ef69473956bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6084774e138106256a64ac04b7982215238030aeaa01683b27e18b49dcf38e2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ffb170705de7d2308b5279d0a1021b3f1ccc4ea39067bfb5c05c23e12ef6bb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae1a437c4e5e54ef88a9a59d6391633cc09c7b3c7320ceef4230b450364a9da6"
    sha256 cellar: :any_skip_relocation, ventura:       "8070f70739bc90d8c318087322f79f9b5a6fe9e499a8340993828a71f9aec55c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8daa023a0a2939b6829b4bca1b471bfbf4897109f7900d538f1571d3d6f0538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372be0215ebb1371b04707ea21375a3c7acb2d2e34430455999a4c1f77eac999"
  end

  def install
    system "make"
    bin.install "lzsa"
  end

  test do
    File.write("test.txt", "This is a test file for LZSA.\n")
    system bin/"lzsa", "test.txt", "test.lz"
    assert_path_exists testpath/"test.lz"
  end
end
