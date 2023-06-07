class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.6.tar.gz"
  sha256 "5dcd87866a2eb7ba5473352430f294b7ee9edeae8f1b3fdf9503e4cc01273b21"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a599a8fa845f3238ffd7943dceba9e6def43c72e8380680d2311a5a888912b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df63e64147f3e260955a2406300e3d528559021e13a244db2ae6f469f1a65196"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "411af1165e4132ee2eea4d17ad78d2a673e80f5474ca72789df759081e270fc3"
    sha256 cellar: :any_skip_relocation, ventura:        "6146eda1cb5cde2c78c8fd6be27569e3e56d2441d7bb3595d2ed80d4e3248b66"
    sha256 cellar: :any_skip_relocation, monterey:       "73174feec3affdf78b42529862928644075d0ac19a87505b55204cc7ddd40186"
    sha256 cellar: :any_skip_relocation, big_sur:        "abd416bf268676a311c4e1229dd440b8ca96b3d3ec94bc278814e7b65f147f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "300e01e5f31b16dc085180c35242b504f35a55cce0a30d18aaf2e49900818ebd"
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
    system bin/"nuclei", "-target", "google.com", "-t", "test.yaml", "-config-directory", testpath
  end
end
