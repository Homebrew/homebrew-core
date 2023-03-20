class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "46e7072cdeb01bf36a48cb6dce3d4a7cfa9bb468a996fc1926b2504235fd55ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "251ba5f68fb2ce384a807ac596255f669a3c6a0efd0cf11ef808d65b8edb2c3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fed19e8e25696650cdbf7482f8b6754be3811c76a3a1d9381509ad474090f01c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "deacbe2108dba57bebba059f3c55a2a17887faf4373ec7f968665b8d80c131ad"
    sha256 cellar: :any_skip_relocation, ventura:        "594740426998bf03d635d45c621069a3770f3c4f9f76ff97cddb6998306b0d5a"
    sha256 cellar: :any_skip_relocation, monterey:       "8d5128a5c8c265d2812b35694e8b785e7705e8c50217f1bf50117fb40ec76d73"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2e5897a7924f81dba12862faa5adc1deca79eb6cbad9d56aa5fae9f17ae499d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf2547901fa464a3916fe1c36c9d24ea85b2a167ee9b2c8b65dcdb022dfae12"
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
