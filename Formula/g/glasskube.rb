class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/products/package-manager/docs/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "c044187e49683b39aa89c26bc02dab38781578c24b6ab277c0a58ae811066996"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf1a551442372a2ef6289b9df1dc405691a99f85a92a09b081311e78d90a4b77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "063ecfd9f5070323a625742f6501bfa047a48b75ae7b82034a65019fb28d383a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "063ecfd9f5070323a625742f6501bfa047a48b75ae7b82034a65019fb28d383a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "063ecfd9f5070323a625742f6501bfa047a48b75ae7b82034a65019fb28d383a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e973c658e887038f7e9af6391821dd0ab5c5e8c8e576b5a607f0f786b9a1cf98"
    sha256 cellar: :any_skip_relocation, ventura:       "e973c658e887038f7e9af6391821dd0ab5c5e8c8e576b5a607f0f786b9a1cf98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15fde2176d6a1201b43e0b4edbb5fcffd40d956c77e2885546cc3d5cdf4f6c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ba2615470cf6001762cdb9acc28d84417494d385b53bd4c73a69e7a9109d56c"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/glasskube/glasskube/internal/config.Version=#{version}
      -X github.com/glasskube/glasskube/internal/config.Commit=#{tap.user}
      -X github.com/glasskube/glasskube/internal/config.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), "./cmd/glasskube"

    generate_completions_from_executable(bin/"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
