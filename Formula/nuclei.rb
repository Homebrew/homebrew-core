class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.7.3.tar.gz"
  sha256 "9de2528b7af16fb7bdaf6470fc3ac4a023d0141e773cc4e78eab98d2e086a950"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d92598cb98b89f1416a2095256a2588df0a2a7d6e62fb85e64b39313a09d1903"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a384d35cfebdcad3eb004f06efde5d29029d386ed1aa55399970a893ec48dca2"
    sha256 cellar: :any_skip_relocation, monterey:       "bd9b4f8744fce3d91476f49e2c23fdec5e5acc353fe3ca6b1d02b5bb58b5e437"
    sha256 cellar: :any_skip_relocation, big_sur:        "69dab40d2dd8e3e2c2e2f9f62c127f7229ef17ec289385d61e212d6faf11c76c"
    sha256 cellar: :any_skip_relocation, catalina:       "3d1cf179916076173c7440d669b016a9190b513422ba2b9549d226f28371e159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24bf00f392d54c07db515339e2a60f9ec26e229c3cc93363740c76781366f60f"
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
