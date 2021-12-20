class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.5.7.tar.gz"
  sha256 "4b55e3c9a80d006ef64e38c939caae3e1b962d2e7ebf5e4de9691bfe4504308b"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10219999dfd016ebd7e7f5b863eedc56787a1cb61252dc34c72d78a712c4acaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d7d69fb15b8e16910d519596aa40be65d2e0898280f4ffe4eef82ce09a15351"
    sha256 cellar: :any_skip_relocation, monterey:       "7893f6f0df68eded28462dd544421031afc30cb32928c7daf167dcd77fabf526"
    sha256 cellar: :any_skip_relocation, big_sur:        "86dbed0a18f1de2e1670bea7e238a19f4134ea61c28cb1b3486cffd7b9e20692"
    sha256 cellar: :any_skip_relocation, catalina:       "cbf7005cd9ccfc46a876e5bf57bddc211da480c73188044f7686ea3dcbe4d72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff71b50ebbf23af35a7c8585308cc39d24a4ba1367bc6b6dce7cea58765b6aa9"
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
