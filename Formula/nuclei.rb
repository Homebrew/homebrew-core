class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.8.3.tar.gz"
  sha256 "2cfd25edb6a74d267acad2f358d12ea0020ed521b8f75c0d3e786b4694913a44"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe033ccec92b7c0b3706dbb73b4a0d87347a01559b57656db1d7704078d3f6db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d471618576e0a83e3626a2832322cace8f1a7beb7c8912ba18087af0fd71b84a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89cfbd54d0f5d47043eeb50b257c3a32e2fcb41f2cd2de2e215379512aa017b0"
    sha256 cellar: :any_skip_relocation, ventura:        "a51373ee66925e26ba0af6677c2eb5b4d760aba4181af5564d185fae18feb999"
    sha256 cellar: :any_skip_relocation, monterey:       "ab8bcaf65a72f359225ed1599b45515e175d0165b0ae6c6c4c5ffb542b0d1c69"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ce398586bf1b9d6a64649ec4afe5a0a5881a2e6a2678fa05568f07ba649cb1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3fd86aff03d663fd1c85314fbfad467798e3aefe1edc83ee917a608c97ed135"
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
