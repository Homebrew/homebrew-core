class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.5.4.tar.gz"
  sha256 "542fd1b0aa9befb9e905c29917d2e49d29b2894c4bb221a12a21e9f7b0a2c02d"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa414d0912e0578e0fb9359efc3a01f6d159aa66a692cdfb47457b4a0bb55277"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c9c04fe324b400fd4e72f55139fe59d6da6e5d8493b458b618bdbf0684e0887"
    sha256 cellar: :any_skip_relocation, monterey:       "41d7114e2c1f7cf37bfc0c330ee7873dc83b2625ba3a32fb4464c253c3a6137c"
    sha256 cellar: :any_skip_relocation, big_sur:        "15141214dfb07ce1895077adb5c740e6e5388c2d8ebfe7ad491bd3a45f55a5b0"
    sha256 cellar: :any_skip_relocation, catalina:       "736d8eefbdc153287f203f2ba359e0d7419edee65ccdd8f5b9c45b5abb92eb3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "664e86ba0144078b9eb8bf4f5e50a58ee46c69ae62d272b234ffa0a97ac3568b"
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
