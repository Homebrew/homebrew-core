class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://github.com/carvel-dev/kapp/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "b3052206113574e32a4f2f84985139ca2ece1ce81ab714b5b8f802ae902659d0"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe73d8448578e9c25d2d8d4796f8324ebc7128f92c19f676a897badebaf37009"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe73d8448578e9c25d2d8d4796f8324ebc7128f92c19f676a897badebaf37009"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe73d8448578e9c25d2d8d4796f8324ebc7128f92c19f676a897badebaf37009"
    sha256 cellar: :any_skip_relocation, sonoma:        "18ccb02f72f8fde9f6f795da1d7761f3ce93f80fad9c9f49e8d0296dea9ac52c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c006f6de59bcb6d47d1ae1cbf1beeb15bdd7798fe7573f220fbbdafd5fd5931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd605a305a77e35c7bf97f2afb2f3a982181167a23be08dee14528e850b9374f"
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
