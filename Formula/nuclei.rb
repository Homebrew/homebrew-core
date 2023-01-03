class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.8.5.tar.gz"
  sha256 "9b4cc56c3d86bdb3fdf8678848673d560251baee267e8be424c357d2b4b3c450"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcebdf82b6594941fdcaabeafb1c7d3f0c12f09a64231b9ae64f5ecce214cdaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22fef466a8359b6af0088231c2564f1f7abae4ca24777d5e00e83aa696769ae4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3764917a97d7a2eba40f1b82ea5609ea3a3ddc410369d6672ec041285bf1809"
    sha256 cellar: :any_skip_relocation, ventura:        "a0ea02d811f35bb636a1fe4219670663a18fb7b80dc9231d376bd3b743509a57"
    sha256 cellar: :any_skip_relocation, monterey:       "c1be07fac2e3f23a7e4839c129d60014048df55212e907b13045f247d7e579ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6f60553a44c66eb93102593469dde2fb2fb5536f9103227f6f9f463810968cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c423e8cad0f52adf3b8dc1d58202b4f19e36fe87cd1a4db5ad23d5f4bf7b87c7"
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
    system "nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
