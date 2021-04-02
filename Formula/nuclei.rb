class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.3.4.tar.gz"
  sha256 "58e68672602d06837d27b13ca0e3b682c3a8ffa136b3de7d68555c3629f858a8"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4023a5b6dae604baa3f04dac795eca5304b512c93213b6c6d293ad1f72935d46"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f02d752d77c5cd00138b65c04549a7e1a35980fc860823673c6250b33de2c2c"
    sha256 cellar: :any_skip_relocation, catalina:      "7c33e9725a1d12b48bae43b0768e73672f49c380d9dcdd855983c3829ee1357e"
    sha256 cellar: :any_skip_relocation, mojave:        "33497519bf103cf4d4abf799c4ce419664965d43b6864e2691b6604f544ed845"
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
