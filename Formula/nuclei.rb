class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.4.0.tar.gz"
  sha256 "df42f32cc9e9d032501a9d4aa40b28a60ace4d4c2d570652728ca324f8e2c1fc"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0aa6b5c3fc69c8116bc68f686de08120f33eb014d26b5b1b3dec5b6ceae6772"
    sha256 cellar: :any_skip_relocation, big_sur:       "a18f6a447ffbe8b4740293e77b026d9acf2146999df40fa35f9510508b071b91"
    sha256 cellar: :any_skip_relocation, catalina:      "c667b8c87813faa95658778303a6ca0d48d935e27bbf08c9e36747fa439222e1"
    sha256 cellar: :any_skip_relocation, mojave:        "e43b0329bb6fdf8bc41e1ad16714b73f188f395462e64c0dd7ec4d8f92613d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97674bc91530ba86ff081a8a753eefbec56adead13fbc76799fee34067a9114d"
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
