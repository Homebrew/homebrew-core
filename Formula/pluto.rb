class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.15.1.tar.gz"
  sha256 "a0c294558bfd05679f499cbe700c88ebe895856feeecf7eb9992033a316f2580"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15d01c49039740536479500de905784a25d65a2fa073ab50e69a923c45425a32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15d01c49039740536479500de905784a25d65a2fa073ab50e69a923c45425a32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b98cd2d061f040319d9ef5a039fc1be090a125c15ef880b3ab0c613db92f3cd7"
    sha256 cellar: :any_skip_relocation, ventura:        "18a021bc5eb690618c96512581553afca2ece1adf3d7e0e50ed29b7e3fb7bf55"
    sha256 cellar: :any_skip_relocation, monterey:       "18a021bc5eb690618c96512581553afca2ece1adf3d7e0e50ed29b7e3fb7bf55"
    sha256 cellar: :any_skip_relocation, big_sur:        "18a021bc5eb690618c96512581553afca2ece1adf3d7e0e50ed29b7e3fb7bf55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bee688085e367d75f1aee2d14c7184eed5d36f4bf4ce2c833b16bea78461e4b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml")
  end
end
