class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "6d755f5e1fb8960c4b20805b757bf0d51b8b4b4bdaea8fee387f456279247af1"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25182cb3673ecc130a7388569efd87c993c1df18232239769560490321908d2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25182cb3673ecc130a7388569efd87c993c1df18232239769560490321908d2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25182cb3673ecc130a7388569efd87c993c1df18232239769560490321908d2c"
    sha256 cellar: :any_skip_relocation, ventura:        "9d575ab322f5b909657aa0d6d26121d1499dbf3848a914db24ddf48634c7e3ad"
    sha256 cellar: :any_skip_relocation, monterey:       "9d575ab322f5b909657aa0d6d26121d1499dbf3848a914db24ddf48634c7e3ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d575ab322f5b909657aa0d6d26121d1499dbf3848a914db24ddf48634c7e3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a730adb1713ef8a805957e98d94ec67a70e6aaae6873c1b5b69e183725a81813"
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
