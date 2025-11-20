class Caesiumclt < Formula
  desc "Fast and efficient lossy and/or lossless image compression tool"
  homepage "https://github.com/Lymphatus/caesium-clt"
  url "https://github.com/Lymphatus/caesium-clt/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "30e24c0f2c7f02f5bb0b3e1954ba0af90d9af8b7d06183564ce53cd91d1a67ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "253f921ea234e0213f2149cdfee4b4c1f3f71ef3e52772a148c115074eee2d63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "033f92315638a9d405a0371a2032e5adcb0be7c301b490f49df682159c0c196a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0db7edd4df9b6c308b244ec1a0cdc55444efc66580e1ab6eb243c39c78a112e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4688a7e8a4c4da738f1c5cbdf84773941a8730e6779f17fab7cfc5741eb29ff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ba8edf270d503c2b038eab8081523953a659f69b69ce9d63ab3098f9bf46f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6fac19b42939ee7b7af11c42580e47bd6b0ef00b846f8c1b37f71bdc4c73987"
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
