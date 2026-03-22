class Caesiumclt < Formula
  desc "Fast and efficient lossy and/or lossless image compression tool"
  homepage "https://github.com/Lymphatus/caesium-clt"
  url "https://github.com/Lymphatus/caesium-clt/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "dd6a42baf0e97fd5005ce16fe4dd48e77d7b7e000df3f775473827592b15fda9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0146d6fcbb12421872cf004763e15e87b0adf8f25b4e302aa78d392bc1c2bf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eab106002915d9ff186938a93180da17500f2ec29d5664e1d3ba10e22d208e2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27dcd7ab19a073229cd7d017479328c3503705bd62115ee7c8cabd2db4ad0911"
    sha256 cellar: :any_skip_relocation, sonoma:        "10ac566c4e4d3b2fb9ae4e1902e9d6705728c8566ebf4946e9f3441f2cfcae28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79f69f43b789be82bf645bd962ad588ebfd2ac287f4fc56c42192f09e1c0bee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b717a0b9a29c07a97b92993c1467ab2cd7c2b8e89e24e7c147267357f5db153"
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
