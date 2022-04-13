class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.6.7.tar.gz"
  sha256 "a6a02e2daac1eb186c95cd956c9314c0c64139b7054c4066a2cfa0526f0ff82f"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b812c4839b379b6cc7036661e134036cdde6726e019dee3d3f8a66e3648333f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b818569c5f3dd85cf247f76a06af2add86ba22a7ce705106ca73a76bdd33c64"
    sha256 cellar: :any_skip_relocation, monterey:       "460e4f408812bd8ab777d46651be58ba3d1f5d05e81b4051fa35fc49679be10a"
    sha256 cellar: :any_skip_relocation, big_sur:        "31db58d21fcfbd495cb7e93f4e0a41f49b1effe6763b3f355f123e0b97fd4852"
    sha256 cellar: :any_skip_relocation, catalina:       "9e07a2d5622578ce03b2da082a90f56423251c8ef8c7a3026db7efd60a6b9284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b69b4e02080d6fe3fcba4023dec39b5b1a170af296ddd37478ef8ab724cfbcf1"
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
