class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.7.7.tar.gz"
  sha256 "1b80ed46281e25f637ee16fcfd84ca2c458d1d4b4ff04f0087f01bcd2d589de5"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2056f6061a6fe55e0f830fdadebb4ed87f4cd4b0a8fb718537882d5fc89ff144"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "247607173a4812f2bf0e4042265997d0a725278367b9c6ff657dfdefc28e84bf"
    sha256 cellar: :any_skip_relocation, monterey:       "0046092ab2fd264d383db327b69a123597fa57575eca09f51a01b9643a4c4cb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cd7d426a1907f405fbcf84582061e37f0e79f15d1a443c65ed2f8d3e5148fb4"
    sha256 cellar: :any_skip_relocation, catalina:       "60f11ffefa34dca89469e4b275978661cb26597c61c71155612cb154fdbd889e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3ea34dd4732a08f72c3c245251b6889bd944e0c786957ce89530b273e0a363b"
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
