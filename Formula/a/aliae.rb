class Aliae < Formula
  desc "Cross shell and platform alias management"
  homepage "https://aliae.dev"
  url "https://github.com/jandedobbeleer/aliae/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f19a45be5d135474635e488cfa687163eaafc432f8cac4b2b8c566fb216d7e88"
  license "MIT"
  head "https://github.com/jandedobbeleer/aliae.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2151cf96b88e3573d4b519647dc91c8c92f61d613bddf91f6cbe4392bc590296"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9556c1ebdf582a71d06977ef02072b6ebc7e13347518c3dc4a6f30c57d71d6d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "321f588cbb67bff56d287d1fdbe3912a472486337e87fa6d085164d1980c7e22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "79edb4231827bba3045a69abd4b421230bacff1b3e02badbad2a62dd896435fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "005430bade50ff99499a91d05f89b188b2f3df6a8af75c4fe637a119e6649064"
    sha256 cellar: :any,                 x86_64_linux:      "0a0fca71e39d64424db47794642194964c1a3ff010c3ab917555d885da024b0c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "src" do
      system "go", "mod", "download"
    end
  end

  def install
    cd "src" do
      system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
    end

    generate_completions_from_executable(bin/"aliae", shell_parameter_format: :cobra)
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
