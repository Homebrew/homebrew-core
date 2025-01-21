class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://github.com/jandedobbeleer/aliae/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "55c17ccd079c30f6adf5f069e7af3b5070c15cc0b630057468eb479be8fdc477"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdc011365cdd5b160b4255efd8ee2c1622c88c51057c38f342eceaf1d87dfc87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2abecf45850f8dbf86d28267e656dea80a1f82a0af3332a0ad2eaec156fa6280"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b72862b6f7cfacea6cd537943d6dfbe3bdad5e036716b05b06c695db281f661"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a321e9960b72b578ce2c6ea7cd857ac5c024f47cfd3ea3a100a29eb861781f6"
    sha256 cellar: :any_skip_relocation, ventura:       "86ea5fd0896cfe6cd811917e21aa1a57518b5f7b98fcf746679fbe22c45ee2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40afdf6c4894a7f6f5efbb9079a6dfb3d1c8dd1ff8ed63dea9b0e87f612b2e65"
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
