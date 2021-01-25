class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.2.0.tar.gz"
  sha256 "c503b565230f5375339c72872d496137abf8be26c156e20447d1ae0752169e40"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf27703a6eb5f03a9c52e9aba2b4803b2da61fc55bd0bf0f825e75b13d3aa425" => :big_sur
    sha256 "209ad76cc1ee1f93c1d5e71776d9da4e27b0d527fb7ab70439c6fa4500f632ca" => :arm64_big_sur
    sha256 "00c3dc4a1d22d4b4387e0ab4eddc769b2183d46db1069118bc0157d71398b404" => :catalina
    sha256 "93a6882b2612447957dc350faa6488028b0a8b68b43355a31f5aaa978de8aa77" => :mojave
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
