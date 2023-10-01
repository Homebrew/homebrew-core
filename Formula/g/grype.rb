class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "d20e1fb2fdc28af123ce197ceef3ac9dd99327f3a298e7e3e2eb1dd5dd7b43a3"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56bb1cc2790c72bb725523d05eb18cdc332fd7160184d045c00c4912e17e063e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f97ee2c9092d9c2438be2c7c485fce6a5994b1270f4d88e024a0564f3b67604e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b62d4331cc0393e175981174ee2028e896ad08a0ca8f7fec96e75607f5f8363"
    sha256 cellar: :any_skip_relocation, ventura:        "c6612b1d53bc4d5b637cf4e9044b513ad5a1128c882c590052109e8e84b3efb2"
    sha256 cellar: :any_skip_relocation, monterey:       "bae7a8a6d055012e2b84cd572f36ba1b0c0f56e4adf5976eded65a302fc04a42"
    sha256 cellar: :any_skip_relocation, big_sur:        "9abfb66a4a4054f07cf01def2e89022c9dc7bfaa7d657c6299fb906ff4673096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3613f060f1a319e58bc276c4527d74547cc6d344643f627619050981d3aa4abe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end
