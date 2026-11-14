class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "4562cc50590640460d7cf7b28d28805db0dace76a70b0329f3cb51b96ea7bfe5"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f233ee807d14c24a6ef63092cb98b58a7c40bd17efd8d433bd3fd535a17ff827"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c60aa1367a9f8c4579c2cce2f56c3569cc8d49b84636a83a42ae0f2a5031ffec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76a1cd777a80756aa9bdd6e91179629ef62b6c4adc590c21668a7f6344b58cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b91aea64df6fb71793621c211fd7f7d76ed69ba395e73785efdd3bba814b8925"
    sha256 cellar: :any,                 x86_64_linux:      "e8efcc1b8496ab6e7eafc5dc828e4259b30bfd859e3d000ae2aa2dd2295ed4d6"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 1)
    assert_match "connection refused", output
  end
end
