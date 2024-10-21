class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.3.5.tar.gz"
  sha256 "aafdfd00a65c72bf1414934cc932b262316f167838835e619b7c079db825b569"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03059d453a8806eed3ccd6b024ffdcc0d7e9970a6681e330bed8a5b107c9b567"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27856237769ec57db669925a7d55f7fbf5f448f94bb65d0769f1c3bf8151d49b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a47312817cbb44e2d585837822a314705a4b88b14213db4599659f2af8001226"
    sha256 cellar: :any_skip_relocation, sonoma:        "5548a3a87be18a653320073ae69a520dc95edf6ce554b91cb429043391075065"
    sha256 cellar: :any_skip_relocation, ventura:       "ab84c5f7d1261c4b8dfd7e6f58cb402a4ade469b12985293f7bdcc3685bbd063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a46e011e0711006ad425b94d4cf4252f5688071b1bb979b4bab6e14c2880aab1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
