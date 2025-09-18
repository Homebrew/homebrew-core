class Caesiumclt < Formula
  desc "Fast and efficient lossy and/or lossless image compression tool"
  homepage "https://github.com/Lymphatus/caesium-clt"
  url "https://github.com/Lymphatus/caesium-clt/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "97cb373faa583226449ee71cc89fdad275afd3dbd1fc22a0b82d25959c95a2a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10f232bfb3dbed5217deb1f15f43f27acb5a595b89f6f99828d42860e24ecd5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a236e8bbb333cc9a132161d61679d544c5ec567beb5001dd0d2b5c010ac38bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1b74483cfe4a0eb6b23239573a46b03b86a87871316497ce26ec3db4429545c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "115e5940f0a8e6164a82752ea25565d8f8030b0ce3d871e81ff26b1f3ab20d08"
    sha256 cellar: :any_skip_relocation, sonoma:        "25d8f5bca5fffdfa0a23afe337174c0ce2a2c98e87483d135fbf7d8d61983823"
    sha256 cellar: :any_skip_relocation, ventura:       "774a6ef67c8b513c09a0aaab7f11cb02d4f1ebd02454d09833e6ad5aaa848b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6a4219b4ff10b170772c5e5d4a14a7799e4bb303e6820057a256c42ea577bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eec60efc476797c2beeed0f61248eac1d63aaccade9037b2eb1796ea508e7ebb"
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
