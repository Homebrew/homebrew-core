class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.9.7.tar.gz"
  sha256 "4ac73b7448be908dfe2e69275e7a93b4eed12a17de09a4b20dbcb03674441915"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc52c65bb2d0c249da66bb25ecd22f66e0767bdc608a77bf1e755913abf171c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25fae4e70136bfa518cd133feae816f17bd950c430c131a6785a632af20040bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f012c69ba08584160835d43b2c88ea513414b3e8da39fedc0f96553e60d9e609"
    sha256 cellar: :any_skip_relocation, ventura:        "a0dde99b68c95fc90f73e5f1f9999e162bf0091c169f3a16d5379195a11161d9"
    sha256 cellar: :any_skip_relocation, monterey:       "9b561a37e4ec95f3d536155985a122ab901814bbe32947995ee1071f2554efbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "33b7afb712f3f67d05ac56e5f95518503b98f56f27321ae9160f713443fcc50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac467199a2ed61ed544322020af98ffdabac52481227a3b0af49fa1306aa6f0b"
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
