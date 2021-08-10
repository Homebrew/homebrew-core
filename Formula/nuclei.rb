class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.4.3.tar.gz"
  sha256 "71e9ec1892e56739a04ade2a58dc86d625157a85842685964e0e0ed215e8b05d"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62f77d1cadec3292a4818b041ca9e6687a56990f6609a5fbc9e744b47f5f3534"
    sha256 cellar: :any_skip_relocation, big_sur:       "25d700241cfa543fc861490de749a5093e86e9d03aa747eda4b8fd82bd0e05c1"
    sha256 cellar: :any_skip_relocation, catalina:      "297591ebbeb74fd78f6cf3a6d56f7d220ad2174c4b26499824f33fde96009fe3"
    sha256 cellar: :any_skip_relocation, mojave:        "0acd79c7bac1dfb5e5e11ea120597e5639689f6818d486c17be59b7d5ab1fc0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4956514956722b0dcfc37fcae7ce49eedfabd7e21ddf7bc699bfe379f0f2e225"
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
