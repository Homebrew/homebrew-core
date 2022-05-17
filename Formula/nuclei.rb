class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.7.1.tar.gz"
  sha256 "a6283e34067a6c40ff9e239ef69c53f246f7877559f99490d65ac566f56fba84"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e2f436f05cb1a424d543835c20350f88792e2d1c47c287088aa0165a15705a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "beef58316dbcb2b38171477a920cf55614a6e56939fc0c183776651c036d73dd"
    sha256 cellar: :any_skip_relocation, monterey:       "b217f4316e4d32c4d82e55bc16261ad9cbbe285b73c639bf534ca86d643cc5ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bc65016bb92f1bb26ff117942c9ef6417eb39d01a6b4dd92a1ff225cc162d40"
    sha256 cellar: :any_skip_relocation, catalina:       "bf66eb00b23ec7c9fad34a547c16c96d8ff58027e28482146dc7e015bc70fa02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b02983ce62af51e6e1683b84577ac2eedfea0c6d7bf09199d9f9f7f3d99fcd"
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
