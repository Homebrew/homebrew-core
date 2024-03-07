class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "0cb5659b8fb22b07e7cdea3ca5b6c46ca6f8e6d02204577d713fcfb0f67b7a05"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb4d609b1f2a416a8fb34a4977993fe03b271869a8a6e9795d06d6c6c4a21024"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b1189590ce8f41cd68cf3104e3eea0a2885a3048347a7a4325ea119deea5a5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03e226c679b023b84fde6a4a927d7b4202e21bba1c7d435aff1a2420107263a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f35d393db6c2dd7ee20f655e1819bec892b030e056d7eb2f2c26900fe85756f"
    sha256 cellar: :any_skip_relocation, ventura:        "a4b7e2b0ed73c63e32c607fbe74e403bdba93b924d4567011ec27f90e9cdf5bf"
    sha256 cellar: :any_skip_relocation, monterey:       "8f0eba7ea1cef835aa0f51751c5e5d05f5cf78f4f4a0333322212dfb7e50467d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30a28c91ca247122a29bee8071dfb2bc87656020d0fff8dc838b156283d7bea2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kubeaudit", "completion")
  end

  test do
    output = shell_output(bin/"kubeaudit --kubeconfig /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
