class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.7.0.tar.gz"
  sha256 "d9a9634dff7827095fc2caf1329aae60eecc1b0043c0b4fa0d84eacd640fb8f5"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efe194cf8213a0f27746c0b35656dbbbcaecc27dfd376adabb14c084959c7e7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f948280b0b3fa9b1392e3fdc9c16cd76099b428f563536463387f004a88bacb"
    sha256 cellar: :any_skip_relocation, monterey:       "7e46156aa2fd26c47aeb96e855d31c010bea82dabc9afa03696d8f5a7d7925eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a53ad605b5a245c309a4efb2568cecd810d7f2660075222b940c3ae620000b7"
    sha256 cellar: :any_skip_relocation, catalina:       "703bb7e96bb73d9e4d1aa706ad711658bbf47ae3a064ebca769099474628a069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d95ffeaa0af916993abdd6c06871f8843870e5d1fe828890367e2fb893eb7ce6"
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
