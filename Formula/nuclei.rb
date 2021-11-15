class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.5.3.tar.gz"
  sha256 "391ca42004abcc51c795b528c6d8a140921358a9d5102bfc59568a3bc2a59035"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad28b31dcf2fd347c69d18e184ca22cb3d9868041401316623414e3be9059373"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d48da6487e7d8f98e7a749058fa49a7c521079eadfd4bca8217483b3a3781072"
    sha256 cellar: :any_skip_relocation, monterey:       "04804a4033e230865e59bb216762b25f198eb816a9b7e2e6bb1e7004b8d49b94"
    sha256 cellar: :any_skip_relocation, big_sur:        "34390c65046fb772aec5d20477115910d3ef897208b98b990382abfadd276bb1"
    sha256 cellar: :any_skip_relocation, catalina:       "0f01437be36fcea84926d3d09fc7998e82c13659b01dd2640318f6bf79464e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2afa4aba5635d31a81b5c57170fea5cf7b219bbc9bf27f215d757e3bddaf5d6e"
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args, "main.go"
    end
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      id: homebrew-test

      info:
        name: Homebrew test
        author: bleepnetworks
        severity: INFO
        description: Check DNS functionality

      dns:
        - name: \"{{FQDN}}\"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - \"IN\tA\"
    EOS
    system "nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
