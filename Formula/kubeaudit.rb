class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.14.2.tar.gz"
  sha256 "b3ab3339f67bdb2c8fa310428feae9a203ea1c8458337474c4c452a0037bc44b"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fddbcbf7cd3c84264ff76ffc533fbdc4cda773c58152b697ad578286712a3d62"
    sha256 cellar: :any_skip_relocation, big_sur:       "f33fcdeb51a461850918e8bed31c8ef2647b26e4cd851a1729996d751434f9b4"
    sha256 cellar: :any_skip_relocation, catalina:      "ed46f15a76ecb0c6496818d7e5bfbfa82408c7451a67180ec554b2044dc25dd5"
    sha256 cellar: :any_skip_relocation, mojave:        "e8aebb94a49195697799379ae7b8b75b26f7be08ce297764551e4e2921edfbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "073b5c7e6f66dff1e30ed0a0599e65d06cc030b5a7dca72ab349865f2a9dc8f1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
