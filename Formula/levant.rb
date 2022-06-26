class Levant < Formula
  desc "Templating and deployment tool for HashiCorp Nomad jobs"
  homepage "https://github.com/hashicorp/levant"
  url "https://github.com/hashicorp/levant/archive/v0.3.1.tar.gz"
  sha256 "a2e078168cfe24966209f34f9c0a677df3ff74e22a0eb387103c0fcb68187a53"
  license "MPL-2.0"
  head "https://github.com/hashicorp/levant.git", branch: "main"

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
