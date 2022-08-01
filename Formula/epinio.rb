class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2066d00a6d91cc1b5410b90cad4f88d8e1be9dc4c013db50e80c516bb25c07f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3714c86675da237144b4c67459bb47128eb7278cde1daebed292b094fc8a8fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdb0748299b75d12a76bf0b6449309a0dddcdbc4348594169fdfc8c3e44e54d9"
    sha256 cellar: :any_skip_relocation, monterey:       "aa29821ac163811c6ef2fb8ecdf8f0344dea1e114c611767f3a98c3886988cb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "feaf5a4b5d571b7edd05bbd0f1c1567efc73745cb3f089f11551bbc20b1fb01f"
    sha256 cellar: :any_skip_relocation, catalina:       "11c35dfd5cc1e56c330d22344f303496d7ada2240466f7fe9c6d6d1d14b1fa63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a73fc03d3109b06c062ab16c7b367c156f8f6aa4d929d4429c019deb80ed8e57"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
