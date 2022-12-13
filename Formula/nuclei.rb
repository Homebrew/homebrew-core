class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.8.3.tar.gz"
  sha256 "2cfd25edb6a74d267acad2f358d12ea0020ed521b8f75c0d3e786b4694913a44"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "251e0786b36e6ba2e912c7fac462060a89f01d1426c1abacdaa4a6944c7752e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c8345c1fd6bb6ca0e133e8d6a542045a70fa97696225d6fb01b3eec784a7f5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38077c74f48a367d40933112ee5cc70169d0707b60e17efac4cb68b5a7844a72"
    sha256 cellar: :any_skip_relocation, ventura:        "1af2ebf936eec9c223f992a8b40bd2790f34332afb42c1dbe605a29d60cca568"
    sha256 cellar: :any_skip_relocation, monterey:       "a4a027df22e3d7fabc17cbdfad95d50c82a26c26afa91f5a9011478905aa7595"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7e08420fe928711e4fb716fd086b1a64e9aad76fc4e83fb90cecdc634bdd508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94302fe1b21747a33fb8c5fc84a4106c41eb6d7e614f26c924a730796873879c"
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
