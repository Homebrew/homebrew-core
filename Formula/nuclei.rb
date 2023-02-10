class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.8.9.tar.gz"
  sha256 "18a35b3afe31355dc7e9ec89c492d0ad15eea60cc7a9fec040330e86f6ffdb83"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "930873099cc064a2f2b8927a3d32be5a211cc793a39aa2a74d840f548355a423"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85178ca8f68f7dc2a6931cfdd52ece306ed8ce54f4a5aaa10eb594c47bc4897b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ea180923e86d1b02afdc6cb222407e933954ff7bd5a3b0e6f4a92bb093ae2c4"
    sha256 cellar: :any_skip_relocation, ventura:        "4d03716504390bcffe554965147aa7e4569b5d0aa83c02fff98db2092c9420a3"
    sha256 cellar: :any_skip_relocation, monterey:       "7f6ca3082319269daebdacb82ddcb3db9329bdc9e9ca7905c95775b223dae542"
    sha256 cellar: :any_skip_relocation, big_sur:        "12dd795b78951b9a86548b470984d27ee3c7132f62ac39e98afeab37112a58c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71ac876c3415e44ec09fce98680c558d67530f6190a99a8aca968ff80ef45e99"
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
