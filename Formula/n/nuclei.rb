class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.11.tar.gz"
  sha256 "05ebbdc4ae5516ded9bee1362d01237ed5a82b7c46f0e8a52b892e17f741e6f0"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c972302fd1feeddbfb67e65a67f39cad9cee0d6df304283015e112eaf1e75cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d97de2a63a6e6361f9789bc547243510bdcd217e7a5012fdfd600ca108e9c045"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "773fda22a3cf28246d69229875dfafcd10096ce16e28b46afd71263f4ddd725a"
    sha256 cellar: :any_skip_relocation, ventura:        "bced3c6726a9079c967fb6cb7f82017e1a539a18550c803dd657f4f3a46a4faf"
    sha256 cellar: :any_skip_relocation, monterey:       "1b3d95ed55bcd7770024dbe6ef6b3eacf74c0703c15022db118fdc0f681b6a90"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d4e8e6e3995c797ba157931ce41bf59052f6a1b720f8e28946d944cb7b7f388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "173aec3bd438ab206eac397fef5f18af2c0dd86db90de67863c9dfa772289a61"
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
