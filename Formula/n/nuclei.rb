class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.14.tar.gz"
  sha256 "49e9937d885387faa2682f633f8ccaa17fc21249a164b03f8187740d2bb40a4b"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e9bb409643b923d3c00da126154036b21a51d57b19ddff8b4907f96dcce0a14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00e01bff6a4e020c3d383d1f8b8e0bcf66592bca2d8a4abb7fbcaf170c8c4c5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c3d446a34de7dba42714ea3f8c60efa64da2b46b301d12eefa6b05a2dab14f7"
    sha256 cellar: :any_skip_relocation, ventura:        "832935d5d0be96f22073a8977b15986a92a12f67f2d45e929d3cdfebc1bfff3b"
    sha256 cellar: :any_skip_relocation, monterey:       "c820fd4f332ece83a2ac697b5fde3d09e00527c2622e1b48727c8f70953fd640"
    sha256 cellar: :any_skip_relocation, big_sur:        "40979c3c852c4030f832662f64394a0a83b10a76d0f25492f94d68ddf871705c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7165425628d43c38a336c9da6fcdf4034ead2fd41e66a81dfb551fd77719df"
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
