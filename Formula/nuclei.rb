class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.3.1.tar.gz"
  sha256 "45d9d7637ae7a50789d8d8f2e3024bcac119106d9f87fd52eb4dfc2ac7cddea4"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "571453f62bdc393a8799e78545e983cf00eb8279c59c88d10b7ab23f7ebd1c8c"
    sha256 cellar: :any_skip_relocation, big_sur:       "cfbb21530d09a0130ba426d37f5a3da24ac716c63ff8f4c5027765ddd224f4c7"
    sha256 cellar: :any_skip_relocation, catalina:      "9b75f8da1597f1447220cabf50b4df7de381fcc50e2b1fbe92a742e86698994e"
    sha256 cellar: :any_skip_relocation, mojave:        "e9d47b5ad8dfa25082bc84591f9aa6c98704fd22f1e531bf90097c16a03eb604"
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
