class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.2.9.tar.gz"
  sha256 "a30242402521f0969a879f12470c73a1afd9c4d1ed9b71533a19305f0abcfbe3"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b0be99bb89c8be5f5effcb4b2e996a95dbef8e1e8feb74a29c527954dda9a01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c66ab247989157319dd779d7badcf1450e12208f47d808c24d73fab3733349ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c82148e8b52340d65e412eb673a8f577901563923d2662351b8f1b9f55be2cfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d76d3b507e1b8950df899aa186ee45aad3230955ebfc548cc2c515044edf1788"
    sha256 cellar: :any_skip_relocation, ventura:        "bca2bf39422dfd8665f5fbe8269438eb3685a495507855adc0cd7e9d726f1e2f"
    sha256 cellar: :any_skip_relocation, monterey:       "9cfd29064318af87cb3471d85a1368798a0db3ee13ad4a9a9e6a4fca8bd6830f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b022366f395f2fa881930cb3f022783430cb524ccab02058b7069d35f45f946d"
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
