class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.7.5.tar.gz"
  sha256 "19d421db99f0f1269adb152b619de4c4b820c822adb48f6bf9b0d89cf23d441c"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52037b6d0952db32ea138b42aabd7a1688b7d9d9619c7295ea1fe881fbe1f280"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "962726b5b160d43ff903e427159bfced9c02ac20babca9a49aa347d2d42d88ba"
    sha256 cellar: :any_skip_relocation, monterey:       "76d2eebe0b1d212f35b83d98e41fabd5a3cf16ece6a2526313ec26e7792773d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6aa6d8e80440853473d6562535d1f3124950148acaadc087c87f386723d64bfe"
    sha256 cellar: :any_skip_relocation, catalina:       "c7a2928c76819b3c8533b79a6cb7eca7a0ec2d2984547bb8b3acc622d77a92c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0b0fb358906dcc875747ad34b2be3b25a078b053f906f2cab0f51d6e6e487f9"
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
