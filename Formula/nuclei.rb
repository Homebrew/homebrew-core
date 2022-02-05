class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.6.0.tar.gz"
  sha256 "0729b74c5ef772dcb6f8aebe3b4b4513e1d66af9afde80fd3d70876beff5ef92"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1fba6a84ec376e1912a92ea06a4646e1864551a53c39dbd912a32d08216939"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47db66b377a63dd43513209693eafa55dc49d09033c1604ba6e10d66ffd89e4c"
    sha256 cellar: :any_skip_relocation, monterey:       "2c837c569b5d6e18e6ff83855eea8d725e0c1d2dcb962b6f663e83b00714109b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f21088a495fe018ec1ca1170ecf6cb2cb86babbee7c3df2e2a124d36562b731"
    sha256 cellar: :any_skip_relocation, catalina:       "c687cf2f21027acd8b556b97d34e285a68e9fecabc55d3cb1dd07d312a665f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed0dda94cd0d9050085e173bc453e1892216086acbce67d65aedcd1587270b02"
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
