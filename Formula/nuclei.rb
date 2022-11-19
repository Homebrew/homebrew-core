class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.7.9.tar.gz"
  sha256 "898b5646bcc25b96a96b067e11738fea0529df773a351d6b00ce10c64beb62fc"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cf9e19eff2b13519b85521e5721000d737c11f33c898ed63f8bd7cf07d34b49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce87ba06ae6e0190c4a375c2c14ff3001e9f25cdc9723c957acb0e7b946cb933"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4200795e0ffb29fbf63774771a8bc1f09feecfa5e904023448341c78efb359a7"
    sha256 cellar: :any_skip_relocation, ventura:        "34c4915681eaa63116dd1b5ec5984e583ddd52b71a3b65d2e859574853be6374"
    sha256 cellar: :any_skip_relocation, monterey:       "9ea6e5fffc702e5eddc5c5b98f6f42e97034e0ededeae617be9d4ab96e0473a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "70d2178babbf796cc7ea926bfad6df7aa4b56bd9a2e728d7067741e865a781dd"
    sha256 cellar: :any_skip_relocation, catalina:       "810681f711cd3afd0c09d6807a5aae41982b22922eee37e6b0ccb064ba666798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f50b583bbad98144349a0b2f434f9b4fd6af9d73aaef05a48f37fb746fa0292"
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
