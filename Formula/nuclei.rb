class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.8.8.tar.gz"
  sha256 "fa9599ada5ecddf9d17eeccc5c745704952402cd4ce49bb9bcfe77cc8dcde5a2"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d64958f8af6ddf20ae83867a2bc07ec5b8a97a411f39193986136ab30a96ce4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cc22fc9e7c274d7b93c13c11456dffe8e2cec4d39dae3938fba2e884ada0746"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "285e129d6a6cc946c72442ed2fd796f880494a5c01245086b6d267f007e76a26"
    sha256 cellar: :any_skip_relocation, ventura:        "08b7f7adb80de26bad97896cc39912d7211464c7e3d6d3f7c1d1f01db0669fb3"
    sha256 cellar: :any_skip_relocation, monterey:       "7f4d3736bd3a03c6339e08249b308cea72571eda8f5b6f35132747dfb72e43cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "6879cc031f2362f957473bac067ee238619b3b23f3411a323dba7c1c507f0727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e37068a0095bb192537389e9ccc7dd20b81d4ae7f9e81e01bff74cc621657fe0"
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
    system "nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
