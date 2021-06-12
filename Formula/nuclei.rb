class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.3.8.tar.gz"
  sha256 "e89b5f366070a823d305eb20d1ded552d694eca6926ee88be7b4d09fefe422f3"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e78cbcaee02785e7a7642576bfa478d4e25fd74f0de9d3069001c8b45aa48c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "f6bba8546c9112c735584a90a46959405394ff0b50629148eb6786aef2aa42ce"
    sha256 cellar: :any_skip_relocation, catalina:      "7d54a4de80dab9bc4b4405542ce908464e76396c444c9e764a2eac832ba624c2"
    sha256 cellar: :any_skip_relocation, mojave:        "754a3364077f561c3e97dd940b1668278594c87163d51642c432f1df886d97cd"
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
