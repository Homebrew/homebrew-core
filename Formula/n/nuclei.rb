class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "9c7188baa161430942a751f2c95fa1c557d1afa0846110a8dcc08167c97c8399"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9120748348497172bb5cd2f7f48ad3d57636d2065c1a0ffedf04d7d9e2224e69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f9787db478e149a2da92bc8a59b89cb0294b00c3a235b45e7cc1f49a445b690"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc3c9d5f756f9779902851bf6289c48bb8d28cf75405bd232ba2af2fe80bb04e"
    sha256 cellar: :any_skip_relocation, sonoma:        "57e0be39abb3fa8be9aa0f63bb066a7dfb0478be7d601d35fe3a6b73a7f74f94"
    sha256 cellar: :any_skip_relocation, ventura:       "34bbefb9a45c131476c25162c22e32d304ba4602f4a56c1ee825dd88354b5bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e34ece3e574ab390912522e0b84d4f49570135ff61e719fe24c5bc3e50f5fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cfffb8f5268e217f1f213835965e55d599962394390c0b18ea8a2af9e80c60c"
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
