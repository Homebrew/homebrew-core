class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://github.com/carvel-dev/kapp/archive/refs/tags/v0.65.2.tar.gz"
  sha256 "1f14fca0b05366a4474c53f0b0b22e0d36879755ede656fdd96747052f1044a0"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46dd34c86fab885ce4a1ebeef73e140c7fca445a802b2a2ffe3862fc0fedce46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46dd34c86fab885ce4a1ebeef73e140c7fca445a802b2a2ffe3862fc0fedce46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46dd34c86fab885ce4a1ebeef73e140c7fca445a802b2a2ffe3862fc0fedce46"
    sha256 cellar: :any_skip_relocation, sonoma:        "c64359c517cf4a3cf156b6d3c88204334146b567a80838f3751d04adbc6cef60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da998499e66350e9c4fabab2b6836da0d8568f797e4d0440dc85f23574afb912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09e0e6dda2c9e23a845e0249404232ea3834bec67a4cd2759e091fd37367efa2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/kapp/pkg/kapp/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kapp"

    generate_completions_from_executable(bin/"kapp", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kapp version")

    output = shell_output("#{bin}/kapp list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    output = shell_output("#{bin}/kapp deploy-config")
    assert_match "Copy over all metadata (with resourceVersion, etc.)", output
  end
end
