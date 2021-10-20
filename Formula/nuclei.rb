class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.5.2.tar.gz"
  sha256 "f10abc813e7b5ab4676dd4a6b238b45f9205796659a0a91a0404b2d3945aff92"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6802d6b0a39b74722839112be840b1a5a5e5a7b7891367ba9c1f37348ab9e8d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "604a7e45584388acbba33cfe400ea3380c376bd4caab99bb86da40c6a8349dcd"
    sha256 cellar: :any_skip_relocation, catalina:      "d3169586e62a557027a6aaefad5ad354ad7454fb135dd1423c4994d5a3044ba0"
    sha256 cellar: :any_skip_relocation, mojave:        "ffe8b9f81a3bf0970d3dce0b7a43589ed3b2b410133d0dad1dc403ae6636c3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9927f6783663eca976097c2f223bb7bc2ffe212361affb57a7105c4a4637ad70"
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
