class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.19.1.tar.gz"
  sha256 "b0f9bcf8f5251fdc7ffb88e4eca354ef4ad9ba4dd784415fd49f115c9a720a66"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60e44ad82f32724df8a32bce8eea21f5c203c0d89d8725bd435da103d517cc97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "019aebda513b5ce1fc7ced8923b00975219316694713fbc1d84adbd381a96f9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c3feab8219fdd973d53166049fff39cb29ae26c287e67f3e96ecbd85fd3de9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5fd21317284b0f75e1892a0594cf8e9a77bc419e9076a256dd1136a4b1ef3d0"
    sha256 cellar: :any_skip_relocation, ventura:        "69eebafddf34870a85114feb07a79d7e5e4d94564ff8ef80a76bd243611e8a57"
    sha256 cellar: :any_skip_relocation, monterey:       "2bb0c222bf448a9981cb48dc7b548bcfc8c5099688851ed1a920bf36f7a163ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c53607a0fd8df0489b1788753441479390b67dbc511be04991dd4e657a5f509"
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
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end
