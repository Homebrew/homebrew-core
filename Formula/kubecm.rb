class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.20.1.tar.gz"
  sha256 "b6db1b87fdb16a1a70d5a832309f1fa2f7f95cccd5cd5c6f8bf351c13c66c9ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48fe08cb1ba840d7e9f767de2ebecab580bbc0815c2d5b022c8025e7a612bb51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17acf90a23ac3425245784fd87d64d4d611e26073fe39faed7c8e0f2f2f6ffb3"
    sha256 cellar: :any_skip_relocation, monterey:       "86e197ba8e1f390354a6b29bf81522a9785e67ac7273190830e995f4a5a7b096"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2b2a60bd69c4b74615ce235e82164ee5c1c4ebd024db1e05918f47db7a69657"
    sha256 cellar: :any_skip_relocation, catalina:       "77591d88014105f3f0cfb5c6643db9a382e4af5afdb5ad7c2b530563ce100560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b51357b0ba3d284fc68b2c4f5a1a93af9785a5f6ed161757dda21e98e69b477e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
