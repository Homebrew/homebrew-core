class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.6.3.tar.gz"
  sha256 "485921f7f0a99f27d473e1af25114f313682e43a0945264bb2408efd7468f521"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b31cc6a7b41a5474876396325b2c7004106fdeb70a0a73b09dbf92922be2b3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0720f1ab40c86504640af11c96a9cde04393eb882632751160d1c0826843d72"
    sha256 cellar: :any_skip_relocation, monterey:       "c80a40f94178a0f2f9b31ffbd902f608e3b14ad11831f8b122b7fea92f6384d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "efe7ba0f05cb3faa9f5fe917a6822e22f7edaaf4e66f6c89e0116ef69425c18f"
    sha256 cellar: :any_skip_relocation, catalina:       "55d49829ad2138a7d7096a64cba53df830d09d4972f2ddcedb3b19794e431cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff3b81d72fdb419b6cdce8665f0bec1439f8fbf457ab625ae5d063bf08461f6a"
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
