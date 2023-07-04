class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.8.tar.gz"
  sha256 "e0eb661936106cb5163222a99926bbc932a40635f9c5aa9d990d0e64636bf42a"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c53f228cdacb51e1a67e1097db1f57c07a7ad9a4a3b69afc847075818e58d80d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f3798778a8ff15f747c8d95a8650a310abac487e4e9397a7aac9627bdde7a5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c66dd4b1e18196f1e30dbb09993c86ff7def499d0a06fc300f2f85e08590e4a7"
    sha256 cellar: :any_skip_relocation, ventura:        "e1ae78796e37207ba701c10fe56cec2e0845717300438685840120312c6c5a53"
    sha256 cellar: :any_skip_relocation, monterey:       "b87b280f7b3fd2647bbd5dbc45e72f0afb13db9cb08f62830e47cd7aaf01f14c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f17d53f32e3eebd1ee55b4f463426430720f69345eebe2747972b032a9f79f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e1be54bda7ddc6c9c64470b06f7c1aa6de6eddc404460a85ca5e00176216f4f"
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "main.go"
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
        - name: "{{FQDN}}"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - "IN\tA"
    EOS
    system bin/"nuclei", "-target", "google.com", "-t", "test.yaml", "-config-directory", testpath
  end
end
