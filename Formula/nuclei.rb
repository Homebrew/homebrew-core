class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.5.1.tar.gz"
  sha256 "77d28a3628fda7b8b08e5b74f3d314050af75f91c98f5de273db7b490b5177ba"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "88172817dbaef26ad7178baf79ef0c5707707c10d2ec6ff0e54bc121c4f008be"
    sha256 cellar: :any_skip_relocation, big_sur:       "233683789047c0195db00ba2d7fb461750efc1110d6baa026838edb9bcd23419"
    sha256 cellar: :any_skip_relocation, catalina:      "ac71eae938c24fd1cd3e0003831264dcfc1fc628b9e379a47fa6542f7e1034f6"
    sha256 cellar: :any_skip_relocation, mojave:        "ab66862dc83b5868fbbf05996ce003e2615842d95e12f50579d8376aef7dfd32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4e93a509593359116dde69cecd22765b3c63a285ed408e8ef2fac91fe234f49"
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
