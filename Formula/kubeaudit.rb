class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "352a1c9d3d3a2492da8ab4ab20b19185f2277112821eb72c3aa06cd1c10c6c4e"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bf20ddd00d5a27ada6cd0e8cfd5d4d605ea5f9a075a086981cf8c38e90d8756"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa3d7f4f07df45af45b92d7e29c6711c31b6c3fad5cf970cbdd66a2cee2e35e3"
    sha256 cellar: :any_skip_relocation, monterey:       "2f66d3f919c6ff546e79069bd681f61fd54fe0e2abc26ac369c7c3cea6f7315d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e97d66dbe39580a86893882df9a09270a73228f6a62d1cf4a8213ba258191d5"
    sha256 cellar: :any_skip_relocation, catalina:       "f322c88f9f7a5437aae40559ab24f2732e81ab13fd882f2227c8b67860ca11b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36aeba1b6eae78b92f505a4fe11f9cad0d45bb0aa6dcdcd13f6be8c3ff8d6546"
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
