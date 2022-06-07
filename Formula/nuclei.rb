class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.7.2.tar.gz"
  sha256 "cf4ea1639005014269e2ba95e06844c2da73bbe162c8c0a5d2fd2cc55fd25d20"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ede0ff320b54e5e70c5dc5c00635424aa3845c8a5a5db2fdf226de6f38b90d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dffdfc6368029f6af044f061da7f4db7c2ec2a48f9fad00aa0c473668326399a"
    sha256 cellar: :any_skip_relocation, monterey:       "3235ceeec6e7b267e3f2ad774afa9c91a7742624d59dcb19ffcc81b3936cc022"
    sha256 cellar: :any_skip_relocation, big_sur:        "34d164273b5fac6186af39ce1de328f73a89f89c65122d8a93f36956ca0e5230"
    sha256 cellar: :any_skip_relocation, catalina:       "3aed885af6090d6db21cbd90b573732d8798dcfc79e26e84828eafef6389bbec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a6f3bff283f7136235e2ed96a81c642a576d39ac44a39cbb935f441d688ca58"
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
