class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.3.5.tar.gz"
  sha256 "c270d68e5ad72e1bcc608c83d8748ff3ad8d11870f358b157ce646424cd7e0bb"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a40ac2cac2e8435924b067fae22f02aa4f85906816f2278a932ae8cbbfe29c63"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b28c362c3c1e3d4d7f68cc5d513eaa745b523326c52bad9dea73aa0ad0d8bed"
    sha256 cellar: :any_skip_relocation, catalina:      "bdce530706e2aa3e276e9a8e3a35a920c9f2a0926257beee43515a5b2ebe9faa"
    sha256 cellar: :any_skip_relocation, mojave:        "9f18986cb8ae72720d59048f0107d1488dd8f010f51fd3a6548c155cbc432e7d"
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
