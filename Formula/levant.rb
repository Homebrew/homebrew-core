class Levant < Formula
  desc "Templating and deployment tool for HashiCorp Nomad jobs"
  homepage "https://github.com/hashicorp/levant"
  url "https://github.com/hashicorp/levant/archive/v0.3.2.tar.gz"
  sha256 "789c01edd7cc0f2740da577375cbbe5f0d06b22e577e091a4413e95a73cc0060"
  license "MPL-2.0"
  head "https://github.com/hashicorp/levant.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74eb2be4120b08e97ce53de373dc0046b42f72aaf4cb15bac6392a1166007080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1259dae3795fb890f07dcd7d3e57dc51728384d5a64474285153e57579816c2f"
    sha256 cellar: :any_skip_relocation, monterey:       "78e5ea41d85bbe1e283db7bfed22d8eddd371b9bce562f01e2f9601e33920515"
    sha256 cellar: :any_skip_relocation, big_sur:        "67bbafd86a8294a11f29367650d2fdd49d5ed95c600c1036c1bc47677b0058fb"
    sha256 cellar: :any_skip_relocation, catalina:       "b781aa48880e56dfec66535a0684c7dc99eedfbb4c66ce3cfaaf5f68b2fd7bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d2ae7deebc5c0eb7666688d15a79fb129d328abb78747280658a3239e4e6711"
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
