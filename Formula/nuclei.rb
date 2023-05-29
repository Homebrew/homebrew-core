class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.5.tar.gz"
  sha256 "1a54899057f84cb6f837fb7e41db5cfdf6fdcebb79389e1d048f1f03d381bd00"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "108adbcc9baa1eed8a34db78ff89dc571babebdb0acd4fe5d04c9bb6defa2fea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b28bb6a8d7606de7ddbb584cddfd7d331d1740fd3dc850bdcaa677400352f03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a637a9b17dbf21db836afe9898c779336c9c888bf04a673113aa434b54911952"
    sha256 cellar: :any_skip_relocation, ventura:        "503c009bf361249f362445fa7b4504f46b591101c041ae8586daebb3cd5e0f38"
    sha256 cellar: :any_skip_relocation, monterey:       "262c0c6d888df4219969a78d7185339e93535001266c3ae6bee10a8b5211eea9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b8ed80c50c170f6840aa607e517191068045aab549cdcea853e8961c6809f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1c2240cb02be9bc04ab397e7e04f5670669493c999ccc5d12544d7b41ccc913"
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
