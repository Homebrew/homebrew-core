class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.7.2.tar.gz"
  sha256 "cf4ea1639005014269e2ba95e06844c2da73bbe162c8c0a5d2fd2cc55fd25d20"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "032e21a97c36df5e6dbfcce552f47b4917801838aa0a50044f200554e94b1e38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "171f68a4bfdd2a9359b5152a6f57f02a01f2a4e7f9c474826ce1c921205c56c7"
    sha256 cellar: :any_skip_relocation, monterey:       "85e26d1873fd6c5b0f734dc94facdf16d44708b5a3c11c4c9158d7ec2533f99c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9604a05559e77dc280c7898d5e6fb35b365e27487a4f362695f78dfee795629"
    sha256 cellar: :any_skip_relocation, catalina:       "c3b29f21d4073b677359b0b43670c1aaaf8c842612f4622ec2494d1e647961f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dba424a17883b20f896dfdc4b05d8c29059ab6370877f1c9b2297da0aef13a71"
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
