class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.7.5.tar.gz"
  sha256 "19d421db99f0f1269adb152b619de4c4b820c822adb48f6bf9b0d89cf23d441c"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a267c87e1bbc8d5dd290e2dbea4039e7f4045baf9a4930e09bc636d99af4f205"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "424e70905b988fbb615dbbf7f5cdb91527b2e343c057762ed4fb07e09fbd479d"
    sha256 cellar: :any_skip_relocation, monterey:       "26d9cd07b38b1765b878120dce3a06e3d1de56adf3a53858d7892232583b2578"
    sha256 cellar: :any_skip_relocation, big_sur:        "efb1926a241ee93bf90e2ab45b90c185f6c4caef0513f1ef19489831d81c1bdb"
    sha256 cellar: :any_skip_relocation, catalina:       "2fa676f0bfd12fe475cb2165d6345bcf9a7f9a89d686fd6d621695de0676856a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3dab18590a35ead03f6eab341acb335e9e0cd9a12bffde6c348257670b020fa"
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
