class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.4.1.tar.gz"
  sha256 "e45ec95b0f9c5d32d7bc75f5a9d6d58ebcfca0c776dda867fffc7c18e91c4e82"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7c9a0c24f4dccbe40763673069ee75443e81e4d941f64ffc9d03712f09105b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "56a64bdbb2bafd0712465c4f7f7dea756fbfb017318759351a19977681a61f4a"
    sha256 cellar: :any_skip_relocation, catalina:      "ec6fe90f74f1b0bb21b8639630cc9c2123106413eef4d43a8786577ebea9a5f0"
    sha256 cellar: :any_skip_relocation, mojave:        "cb57069391c746c6f7730d388a1f3103c5902defa35648b993cebbbb74d409cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cf36d3ab8afb643df9ad5be5e86006d8365b2aedc0411af2cf92e34f64173e7"
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
