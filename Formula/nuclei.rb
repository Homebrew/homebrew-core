class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.0.tar.gz"
  sha256 "43afe2f6d0e81071637f95693933e3a8af30f8c563e701e20d49a1d9245e7ac2"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e87f2a425eea5c7211e5504a55d956b42a625e2ee9acb684601cc4450dd0e34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "149b7c0d3ac05bff5c312bfac201b6f83496285ff9c70ac53cd41b71a663b544"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91d4d3f70afb35ce286a84b82c3d3e8275f6c2d5d8f14421bb4e49ffcdc430cb"
    sha256 cellar: :any_skip_relocation, ventura:        "a51cd6643836c09f0400b848573e0ce545f9b9aa811014a6d9569be38190b7d0"
    sha256 cellar: :any_skip_relocation, monterey:       "3bff82a0c726b63d974645f8daf9e0b84d650bd42eff1f2e6d8e39d8503760d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a0ff6c661e73ab2365cd00dba4505d2c6481f404f16c133e9e8e387683be0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b18e1a1112ed36df74fadd55551ba5f470c605bbaf6a1aa61ff39672a5b5184"
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
    system bin/"nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
