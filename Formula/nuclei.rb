class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.6.0.tar.gz"
  sha256 "0729b74c5ef772dcb6f8aebe3b4b4513e1d66af9afde80fd3d70876beff5ef92"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "853a977c80af32be7a41ccf9077f4c43915913a7575df06f2309a039389d2b2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c09758e278e1068d6158875d7937d3903cdc53df949f758c91f27cbdbd074190"
    sha256 cellar: :any_skip_relocation, monterey:       "96096be4ea7ed235279631d3780505833dd70a291c575f5a76d03869e366ba23"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcfea08129a3f5cd4d822be3eb46fa4d81227a1ca52994d782c088f7640daf28"
    sha256 cellar: :any_skip_relocation, catalina:       "948eb36cd58371f532e40e5e532ad7c3bfec2794f15f29366232d5de9d01031b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3e70b03c8358d091b260137e06c3f57ebe97af2c4c953527de2cbdc05027e4f"
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
