class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "90752d42c4d502ab6776af3358ae87a02d2893fc2bb7a0364d6c1fdcd8ff0570"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed7e03a89484195517aa271235e43c8c9a9a3a3f85bb8ab5984c5c51a08dc9b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed7e03a89484195517aa271235e43c8c9a9a3a3f85bb8ab5984c5c51a08dc9b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed7e03a89484195517aa271235e43c8c9a9a3a3f85bb8ab5984c5c51a08dc9b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dac6e3a8165ed695647bbecb20db5812bd0e6af8b71cdfc02a711b7b6ac8740"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47a3f26a2b6da84e82db2c19f0563f0e25831b36958b503580539de658e399f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9065ca35ea616d7e86b5be5c1a521880b56227dca2553e308f44b06c13d094b1"
  end

  # https://github.com/Shopify/kubeaudit/pull/594
  deprecate! date: "2025-01-10", because: :repo_archived, replacement_formula: "kube-bench"
  disable! date: "2026-01-10", because: :repo_archived, replacement_formula: "kube-bench"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kubeaudit", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubeaudit --kubeconfig /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
