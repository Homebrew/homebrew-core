class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "a50d67d18deb1bc33c6988b79bc550c0207efae0ef588c3825d77ccf6d4c78bc"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a11b671429a452d3ac417749d0048af77f63d6a8b8efb6a6d2431c0da77564c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "408797ab648d83510971d1a909b9a98cc05d1b828b47f7d149271e0089582728"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca122c4a2728f7c74e4e4c537d95e64ff264f8711858082ad8c148bf69cb2c32"
    sha256 cellar: :any_skip_relocation, sonoma:         "2061a393b5d7cd49295da47d1247e858febe6370dceed370094afb0e60fc6314"
    sha256 cellar: :any_skip_relocation, ventura:        "0f8c9214f5b3cb15036cadc712eb6575d5af9665c3cb7890c47aa386f0065fe5"
    sha256 cellar: :any_skip_relocation, monterey:       "21f153d9aa487fb719000858ac8c968314900ac7bdf685ad4b3f72fe0560b8cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f47d4bc68b0423962f0e116ac11693a2c46722e2759111fa3417d04ce5090a3f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
