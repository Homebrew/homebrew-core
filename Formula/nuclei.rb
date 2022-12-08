class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.8.2.tar.gz"
  sha256 "1de5227ccec135c243042c6a9053bf8d3a4b9b5e219984b722bdf2a4e3a4b950"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26d2f85594e77e86d693e4ccc5f2924aa264663fdec4919dc03a528af06adbf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6eaa81e2fcee0d282bb65b8e0b2264c1c2d63f7afce292109e8ff1ceaf677df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6256ed7475f0e7edebd5048eff87194a507813c78aacdb0c4a2804749f38d38e"
    sha256 cellar: :any_skip_relocation, ventura:        "cc74362ce8998258f670abfd0ce194eaa06eec0216e8a0e3e01c8d2347734370"
    sha256 cellar: :any_skip_relocation, monterey:       "001a622c00a30efdf346bbd34134639ed15c56cdcd02b5f0437fdd1910fef317"
    sha256 cellar: :any_skip_relocation, big_sur:        "e523e25b4eef41db88bdceadf2adc8e1e403f3f1e9f0b8286a67c238cc75f617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eff68dc7ce953d219edd939ebfa3eba3480e9b792b99c851d2b54bd82bf5111b"
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
