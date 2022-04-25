class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.6.9.tar.gz"
  sha256 "638efb681b7eeea796b221907d8bc5831168dfb2437aaef25ccc6f18f58e7b81"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09aa3249017fcf9d07fa464c21da812e6bd0a080156e1a604345fcdd88fa3573"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "803f688bd25e8cb6b6faa26dfa950c02e48694438b289b0de2c0ac0590fa7f74"
    sha256 cellar: :any_skip_relocation, monterey:       "ad0826088bd87d63407d0b7f249d30cfc9d557e35c7afc8ccc124d2a0f71662f"
    sha256 cellar: :any_skip_relocation, big_sur:        "69c75f5e07c1d2c50639c00b1ae0c6ca610a371a97bcbb8f4f5bd6ad18503538"
    sha256 cellar: :any_skip_relocation, catalina:       "35cac29e784ae6627d230a5f66213c65bfe2190d5d05e0b28c54ee64a29846ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f30a24d6c0117b9dad664a37a24222a86d861b0c0971bc970f225bec2169c9b"
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
