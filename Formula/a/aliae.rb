class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://github.com/jandedobbeleer/aliae/archive/refs/tags/v0.26.5.tar.gz"
  sha256 "fae24264ba59214a657f0e4022e527ecd9459e66eb7bf3fdab1484a2fef78276"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "893962f0bc61841a44fb822e3c73b61579b7547f99d5ddd957ac65cad761bb85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd2ea50e4ed2466e2b5a85376f6b03f664d76ba31fd4f7860a3e253ebc5147a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dea9ce9501d131f2400499794562a1c35499557c72ce3710aa28f6a6edff30c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b057fb7d3f910025e0297ac4029248611d90eb68dae4991f2eadbd5941415b2"
    sha256 cellar: :any_skip_relocation, ventura:       "aa29d6f7f2c54751786bbf7881f5f97d44408f85e55c069c3ea0e43e5850497f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f1b7a1febbe233213e950e1e3766786170543e8ce9f0a6c509af2bd61aeffb2"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      ldflags = "-s -w -X main.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"aliae", "completion")
  end

  test do
    (testpath/".aliae.yaml").write <<~YAML
      alias:
        - name: a
          value: aliae
        - name: hello-world
          value: echo "hello world"
          type: function
    YAML

    output = shell_output("#{bin}/aliae init bash")
    assert_equal <<~SHELL.chomp, output
      alias a="aliae"
      hello-world() {
          echo "hello world"
      }
    SHELL

    assert_match version.to_s, shell_output("#{bin}/aliae --version")
  end
end
