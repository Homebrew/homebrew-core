class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.19.0.tar.gz"
  sha256 "eabdf533280af248c5ded19f0b8224aad9682606faac6c85c0bd0a573e0736d0"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4f8812ca7f5eb7b5b83b99abd0e3e72010cb67e08319f806d0892db21852c86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6685d093fa67117a64dc43a75221b9e2b0cfabc82fe71bcdc66b49109e4c8b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6200d51fcf10eff222c289457ae0ab9bf2ba61439dacc35d8d77fe4e17b65ac3"
    sha256 cellar: :any_skip_relocation, ventura:        "4580ca68cb196642b6636f5037ea1c8954e9298c0b2f643ea2287bd88065ec16"
    sha256 cellar: :any_skip_relocation, monterey:       "817181f5887489a3057ce88ce971897e8d954b77b5b70e20d2a3c33df9030785"
    sha256 cellar: :any_skip_relocation, big_sur:        "412237b327170722119c0ef5701d81436d7743a8fcf1c7c913a17f5bb3a90566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c8b507d0fd2a018343cbc4b0178ec5c480060274eb54f8c9edb6157f6505449"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
