class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.15.tar.gz"
  sha256 "5be9d45a14affafa434822b01784afccc38b46ae6ce80e1c7cfe72f2458e4269"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8207c8c31949eef4934e034f91597d0d57f472287742b628df28041cb84db37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "647794535369587e1add3ffe5d7eab51f6ed9d1d02d1ee37dac186d39b23da36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc9ed876f891ed70af869706a24f82cdc9a3f941001eaeaee243831b7920d2b1"
    sha256 cellar: :any_skip_relocation, ventura:        "a434e5b04efbb41f20bf86883a81331cb78c101718a3b73cea51f4d0b02a4b1d"
    sha256 cellar: :any_skip_relocation, monterey:       "d4cf5c899f217816579ee43faf37eda9c51e616651c4acdfbe91dbc24f8e4920"
    sha256 cellar: :any_skip_relocation, big_sur:        "53d6a7d1d99665eda0c38d32a6e0e40d694799d831d8457fd25861898c143127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f39b21f33988175693515f4ab37e77bfe0f5ff7322b2e5812e5660f0d91a4a8"
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
