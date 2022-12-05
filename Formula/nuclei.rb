class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.8.1.tar.gz"
  sha256 "5dcddb0e45855683feae85c084f343328a42c5313ba4e40b9f6a3486ffcf2730"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f76f5a689567a33551b057ceb7f8b25faa5bd010e14393710b61bc76abdc1aae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f8355936a770431e30611e5af56eb2a9346ad09a5946b2367603439f3abb6ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32bbaae64d26c44c374dde8ff913844f0688774b24f76503093c764832d04bcc"
    sha256 cellar: :any_skip_relocation, ventura:        "70a647733591cd0b6e25f3e6e94631ac9796e5457daf44866173419760897000"
    sha256 cellar: :any_skip_relocation, monterey:       "affaa5c0e96b5f8f100c419e1cfb153bf968e52ad696123ed7b0914b436caebe"
    sha256 cellar: :any_skip_relocation, big_sur:        "eeac75bcf2259632751be4c06402233f7e0ba32b9b189a4e150583b63807325b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5707237713de187ad6e87d4ca8c81d48f52bbe21d1c2304d2c96e0b7bad1a73"
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
