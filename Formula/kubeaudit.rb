class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "e15f603813fd0877d0874ad3122241183ce270a4ed3cb78a3568d5a167446f52"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a76a637fa82f30b5d7d8ca89be8d04a859ea6320fdc3ecb866f21b55e8c9594"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a53a07d37d8aefefb0c96d661ba42f9c715e33a126971baef4841e6b382e771"
    sha256 cellar: :any_skip_relocation, monterey:       "25f0b3829979a784e2a9fd4ce42a0067fabbe982493c82f8bb7b0d7dc8cae0a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "541582d9c1aa954e7583bd395f690c0013a05908254a646b32601c5ecdb5c6e2"
    sha256 cellar: :any_skip_relocation, catalina:       "a08e36f85ca3e87e5e275ee824441217593db75c5e4c1fd754012c782b303122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622aa47244813f8db4a2b434780c1e67ef9e7b8df0dc6364f97c5471417a293b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
