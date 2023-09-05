class Levant < Formula
  desc "Templating and deployment tool for HashiCorp Nomad jobs"
  homepage "https://github.com/hashicorp/levant"
  url "https://github.com/hashicorp/levant/archive/v0.3.2.tar.gz"
  sha256 "789c01edd7cc0f2740da577375cbbe5f0d06b22e577e091a4413e95a73cc0060"
  license "MPL-2.0"
  head "https://github.com/hashicorp/levant.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49fa1eb4de5ae77a728efc129bbfed654dfc06fb2d97a9989c0a078501275a0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "698d495bff4fea26d8d85a35e44d70a29b6a46fe052e9d0cd7a4a5f381a2682b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74a1511f41e293e36a03331fe767beedde31d511db67a1516cdc99d523a08ba6"
    sha256 cellar: :any_skip_relocation, ventura:        "93d00730cef62f3adfcba0e3b8a31b21f3e2e6e388ce6b3e2b821890a2f54b66"
    sha256 cellar: :any_skip_relocation, monterey:       "b1debb65e23d4a1831a4d37d7276b28fbb7903cfdeb501ad3b3c15027161f9fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "b16a163a59df0456d7eec9c90d8427850b474097b3ec331f18067be084649b74"
    sha256 cellar: :any_skip_relocation, catalina:       "52700d152ae1b7734c947afe1ca000ce60c9efdb2c72b7d13e3cdd1081a16d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9843fd7bb066819d4957c1f58d18f6ddab5428dd1ead5a8d6e9426eb853c7ac5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hashicorp/levant/version.Version=#{version}
      -X github.com/hashicorp/levant/version.VersionPrerelease=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"template.nomad").write <<~EOS
      resources {
          cpu    = [[.resources.cpu]]
          memory = [[.resources.memory]]
      }
    EOS

    (testpath/"variables.json").write <<~EOS
      {
        "resources":{
          "cpu":250,
          "memory":512,
          "network":{
            "mbits":10
          }
        }
      }
    EOS

    assert_match "resources {\n    cpu    = 250\n    memory = 512\n}\n",
      shell_output("#{bin}/levant render -var-file=#{testpath}/variables.json #{testpath}/template.nomad")

    assert_match "Levant v#{version}-#{tap.user}", shell_output("#{bin}/levant --version")
  end
end
