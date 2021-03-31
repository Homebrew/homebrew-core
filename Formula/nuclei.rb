class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.3.3.tar.gz"
  sha256 "4b894618cb1fc46e8e1af35507bda9db3629eb826d3269d61c767457ba909aeb"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7834cbf11429c67e1e3a238a03d469304f2584ab412bb51c1b3710c2972dccad"
    sha256 cellar: :any_skip_relocation, big_sur:       "c1bf0daf8a64e11ea4a1aabfd16c059ef7741182c80ecad32e5c0934fdf974b4"
    sha256 cellar: :any_skip_relocation, catalina:      "638e535ff2d2991141bbf0606878bcda8155092f40ac0d80c62f887bb2b84aed"
    sha256 cellar: :any_skip_relocation, mojave:        "811e8811abff7ec008dc8647386e7f8bbf8de5cd7cd6cd8c23b38b378a3916bd"
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
