class Levant < Formula
  desc "Templating and deployment tool for HashiCorp Nomad jobs"
  homepage "https://github.com/hashicorp/levant"
  url "https://github.com/hashicorp/levant/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "0e87c27e2d4be7cd2a24cb0459d0a55f1bb7b5d65e6f7da4a2babd7d95d1bd92"
  license "MPL-2.0"
  head "https://github.com/hashicorp/levant.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8cb3d327f3a6c17677eab41ee6563397989c678c6db90894684c2e0979a46ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c58edcdb61ded77c7f1852bfa19f172d9c72bfa5de19afac3b351f73af2e98e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36afeec80aadd0c4eec3df654890e5675006f0b291f7c0072a77e212fc08598a"
    sha256 cellar: :any_skip_relocation, sonoma:         "63cc9da15372b6135f3f99f167c54198eb2e02e0e3cfaa062cb2955decf86d4c"
    sha256 cellar: :any_skip_relocation, ventura:        "3d7966e44708d954216fbc9cfdd5a3a25fa354cf43614101fa0f2b4405a7d52a"
    sha256 cellar: :any_skip_relocation, monterey:       "7ee4456e9545bc4e175f848a5e5f91af3964180b4f8ec0137dcbe0ba7c420a22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37422a0f475593fbd1213d9ff47edc4dc2258d0bc507733b71443547c5a79815"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hashicorp/levant/version.Version=#{version}
      -X github.com/hashicorp/levant/version.VersionPrerelease=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
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
