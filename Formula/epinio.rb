class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "a8dea6f83ae571774720fcbf5d25c237c1e057c50e39979adfbfeecfbb5616fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f133a5604d1db37f7b0b8a5db0f430bf9ce545aea33af52cdd22e7c562786e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeb0b440b90072f6110c301b9dd034a243f3575e277a4fe52c69307fb25b3268"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "859043f587437fb8891a65fa0d5f3f13352be71d78368e349f003e0155adbe07"
    sha256 cellar: :any_skip_relocation, monterey:       "05ad17370f33778d1f730a1a7524c1c743acd280fda304e132db34f3b8852e06"
    sha256 cellar: :any_skip_relocation, big_sur:        "16009407d24e535ebb3d05a20cf30efbe2c7f29f78c824a6acd36004deb424da"
    sha256 cellar: :any_skip_relocation, catalina:       "e57557769dbf691c2a857a857cf688e72f852c54230d8fbad78eb223d1dc461d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da97a8841d2812a4bb56637a7c8ce29961a1cafc25d1d6d1965e109f9c2935eb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
