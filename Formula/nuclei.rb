class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.6.1.tar.gz"
  sha256 "9982b2fb69d1de86cc1fa1756ca24f9d04d3b7a44774aba403b86b514fe7a23c"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31d606bf894cf242a88f3529461e0bbda968d0e729e77da8182e1e5537113ffb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e79f909ce9712ff24e4dba29ec81f48306e0d5b95bcc77054d56d876fcfdd603"
    sha256 cellar: :any_skip_relocation, monterey:       "e7679000da6e8c606254274ff1c5e3150fee00073a3ba68e646b93e17b0ed13d"
    sha256 cellar: :any_skip_relocation, big_sur:        "04d02da100d9ee6799ee3fac36161a717eb2bf45346a0791dc2e07814b532e62"
    sha256 cellar: :any_skip_relocation, catalina:       "fea56b9a18d9ac63ac28d5a85e170c3b1ccae66cf13233a31eb626f2ea9ecc73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc714ce4d2384fee96219f288958cdb26cae4ce325d879e8e438c4ecd6e407e"
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
