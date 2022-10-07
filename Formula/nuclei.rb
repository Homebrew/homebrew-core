class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.7.8.tar.gz"
  sha256 "91ce140b8dbe0e8cd1f4e49fc80bfa1ec51b841919afd24328419334382832ea"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50ae097b1cea367dafe7e941c572522216f99bc9c0ee4cb657ae4cba71d69768"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2bba6b5fed1f1048f5b814d71b2318535b16938f1016541ae171fea6ead757a"
    sha256 cellar: :any_skip_relocation, monterey:       "f17a3e04dd8c900a5102b37ce8c90b23b264d5be5b103cdb67a19527df3c4a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "2630fcd7ed913d28359ae7909af4fc0a0ae63e81ce3b7a1f4b11f342f5b8e6f9"
    sha256 cellar: :any_skip_relocation, catalina:       "2058c83b96d54dd40f2c08725fd5d2102489da470adfaabe3b93eae3cb82024c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52dd5cd061400d338d9bde5c498ef44e3f98a5151a1de94fa3b7154565fd3dde"
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
