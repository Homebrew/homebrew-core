class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.1.tar.gz"
  sha256 "422ffe03aeff7bb96941420341c8d85d455cd35c9f4beb35c89dee5ee8c575fe"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "280f76df5e62cc6fab4b8fb3925c398c480c60f28937d168ea0312c2d2c25566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72b01e3165c376b072009e04b62d849e140afcfdd0f29e80a8d3798ba44e82bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "161953d5cec07350cd0967a6249484242e071cc05e44514371a4e42ac86156de"
    sha256 cellar: :any_skip_relocation, ventura:        "3cd48b8fe3372d64d9782aa33406051109a722aed970c27b6e7a852868d4dc15"
    sha256 cellar: :any_skip_relocation, monterey:       "d788a751f4416af1e92d2e1f8fd382b05b0e5b86ca43baa86a1b8feccddc5962"
    sha256 cellar: :any_skip_relocation, big_sur:        "71b37afbadf6756c567e8998df84d3a479801472c05bce2f956a17d6bec95104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ce59e81f9149270c1e1004fc6673bc434b7d65ac945e41a9c06876cca3435d0"
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
    system bin/"nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
