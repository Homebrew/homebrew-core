class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.19.0.tar.gz"
  sha256 "82ad604e2b80d4434633860dd81a1d73cd59d54bde7241f4e86c95900912befc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8996539f9c34bbd64da3b9590329e106ccd3ea98c7a8a5fb248a573dbf26ca8e" => :catalina
    sha256 "23672e5018b8e0956569c2bdc051982f5e0f0da7319141237ffb996187c89f9d" => :mojave
    sha256 "f9b683054ff5a6e3e2d121ed6177e398602378a32b70a30ac316cc41fd11c191" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
