class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "a72a3c7297949e97a1718175244bba6d10fbbafac4fe4fac935fb357792dd5fd"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f7c46dae012041d86de28e5297a487f2b8a3fa6d97329cca9c568cb6a8714e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77cc43fe82d8ff38a46f8532a5076236de2668ef0cdf46464904e21dd728e7b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3590c3ca81fbcf2bf32a93029514c9607012999cd6e37e86e15bd4825f1e25d"
    sha256 cellar: :any_skip_relocation, ventura:        "5afce8e9f1cca2160c68421d3b33fc16daabf19f570cc2022756056c634f74e6"
    sha256 cellar: :any_skip_relocation, monterey:       "e97aac2f2de5e15703d45f9bdaeec2fb3501e4a13189fe36ce8d22a2176f84f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7ec90388067e8cd526c5d60d92bce1e03540185ea0c85d2ad8496f275ec9a49"
    sha256 cellar: :any_skip_relocation, catalina:       "4605074050fa2af78e2d45d940e3561237fbb7f6da006e2cc1787af5d78aa50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98d572d3994d5e2c182fde04f2a7ce3c04d8ece8f08d7f8c1e953f4dea11c6cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kubeaudit", "completion")
  end

  test do
    output = shell_output(bin/"kubeaudit --kubeconfig /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
