class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.6.5.tar.gz"
  sha256 "b3751ddaf3c657d5902d9ec10db221ebed9646220fe47fa2f3d978b091f9dbdd"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a0cf2e7020d1eb7c97cccc0e8fea79d0c94e4d2b90fb79ef8d0eca85e62b763"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b09840ab7a118e9dbd7ae2a60e89541cdd088852eb50b41a8a3c3690e8ca500"
    sha256 cellar: :any_skip_relocation, monterey:       "c8cf0ef4fbffa61e8573d8b50348fb143968f4263c0585dd836f83ded7b79327"
    sha256 cellar: :any_skip_relocation, big_sur:        "aeb92aaa5afb88ef7ee7c51045441b9cb40e7771f563bd5dbcab6fb5cc2912ac"
    sha256 cellar: :any_skip_relocation, catalina:       "a872667a9439e09868d01233f2a6ee5642a2f8e7e94901ec02f18a20c9495ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89cf4ab4db2f8f6359012221ffdf6682b011c15d3a6cdd569024d3f36579a128"
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
