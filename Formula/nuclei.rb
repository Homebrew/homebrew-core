class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.0.tar.gz"
  sha256 "43afe2f6d0e81071637f95693933e3a8af30f8c563e701e20d49a1d9245e7ac2"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb35d4c8b3e4c2679289c141f7dd69ab9d24ddd6b775f0de4717ee36fa80b870"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "827624a47675cd4fc6a9577b7062c5f0260b66643c294bcf2178e5176c1199cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87779e93389b83c91985377c5bf80149022f2333499c2031b2974adbf4d7acb9"
    sha256 cellar: :any_skip_relocation, ventura:        "170163e848e8833edca74853256bd9aa65faf371af42a232d7225d315ff865c1"
    sha256 cellar: :any_skip_relocation, monterey:       "c267c635473946d74fbb631ee6510b6903d2b2640a1d2fd6ba46ace481ce854f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fee6c41105e841b54690207ac2bc72330b637b687d5cd5db70e2ecec2ef40ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fa5cbffc3bc58214bff5ee69bb2ccb84cdf4bc15619a53dfa3f9e39562bd8ec"
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
