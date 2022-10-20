class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.7.8.tar.gz"
  sha256 "91ce140b8dbe0e8cd1f4e49fc80bfa1ec51b841919afd24328419334382832ea"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad7850a78bd2d23c6ee1ab40bd66905627ca9369d660949f3c99b4df015f43b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5dfbf48ecfc96c724bc9acbaa426b967c281e000dcc665a8df2a58de72b0e31"
    sha256 cellar: :any_skip_relocation, monterey:       "7f13f7028a790e495be0104231a9c216811cd9410daad6cf1f18657363b4c00f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3ceddbb7b3d002743354a1c7639ea5ae5424733147d16d404d041f6d1f9b972"
    sha256 cellar: :any_skip_relocation, catalina:       "e2ddad3a56c02aae1f5fac065582e028208586b912fe9ee36df512c3e452f95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51b8bbfba076310e661f6f9d31b201e0f631791b1a4a96723064968d84e0c883"
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
