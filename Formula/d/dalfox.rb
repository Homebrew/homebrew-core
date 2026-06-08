class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "5e9429db49cbf5742555e0e4cca1f9fbe507c3979bba7685ea78db937ca7be92"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daa733dca9e4b99585e8f74616ff6716435167a3cedc55339076e0a11215e295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab569100b2326a68e11dff3c10d948b66a11b9a4b263aeb193dd28b4f30575a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "335bb7ab3f56daee3b4c57547372eff2d369fc12babc5421a720223c9bafe47d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef4991f495f68fed894444c438518a2993371413c9e9908a85a17bc7968d94f9"
    sha256 cellar: :any,                 arm64_linux:   "86065a9fe5fe3f9a561392fea5e3c7e75c3355d834e70038793be000735d59f6"
    sha256 cellar: :any,                 x86_64_linux:  "30ec4ec957d655eb145c34890209eb1cd5786a724c9431e18a6fc107edaf58aa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1")
    assert_match "scan completed", output
  end
end
