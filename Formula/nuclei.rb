class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.5.6.tar.gz"
  sha256 "0ace72b1a67d4ec98c5be47d61601f5b83a52121b16f20fa90f3ba6c0995e02b"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b7e3d6238bbf66267879a68c5623d9fd096a8dd06b6c4567544aedf52db1f36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebe7d96f3d402afabd3256639154d9a3bad74ac9fa00be378cdb719a517603ce"
    sha256 cellar: :any_skip_relocation, monterey:       "b1ddc4f2af36b2f0d488184980098ac6616b632969833e0e8c25bdb25dc38768"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c2b1ae4808f01c85f95cb6e89c798d11ed70b2bb2dc9d8fe00c3a6ff355e574"
    sha256 cellar: :any_skip_relocation, catalina:       "6b638a6daa41be156787ebc1f6a4be6a81cbc0255514089697485fa4d8af829f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f68005c5bdc65151fd53f76c52ccf3aee1324c2afbb17e0a60542d122542cff"
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
