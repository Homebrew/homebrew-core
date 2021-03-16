class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.3.1.tar.gz"
  sha256 "45d9d7637ae7a50789d8d8f2e3024bcac119106d9f87fd52eb4dfc2ac7cddea4"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d988cf650094e4424b1a9d3d4c7a8b81774e5a573e5edba7a5d8a98641f0af96"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f0dae029b979bf612256cc972da914fd57837bbbb3dc78c463de9c0baa8d9c4"
    sha256 cellar: :any_skip_relocation, catalina:      "3ca6c861403d163d127c9185bff1c9b3b9cfcaf29e546bda48056450dbaeb249"
    sha256 cellar: :any_skip_relocation, mojave:        "79e0967cddd0ad96ee93efbac1acc645658dcff01323fae80a93901a8b894130"
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
