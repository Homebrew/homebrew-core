class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.18.3.tar.gz"
  sha256 "8c76b4f4fafdec1d50cc3ccb951b434c8607d699598839f9d461849303a5e036"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f08e1315c919a9b722943685d537d7ba32b42b7def26cbcb1aebd30def8f0e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e4c0184ac96d945389e213807767f3aa80183f7d86ddfd20b8d055b610443b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca10e7022bd389fc478946ffb34d19ec2fb96660230ef3580aaa952525acc2fe"
    sha256 cellar: :any_skip_relocation, ventura:        "b6d9f547fdcaf62149e5f3f0e60c224f6439c1ee2ffd5168c89129ad294589ea"
    sha256 cellar: :any_skip_relocation, monterey:       "b96061a1622c0dba74b80d6f9fb176694a0cfcb45acebf90f4ea35069bbb6531"
    sha256 cellar: :any_skip_relocation, big_sur:        "38cb4d5cbd74ca7cf23f3394435928194f988e9c3f782fa9eb9608336fe58206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29ce03ae1f0b010db82b353d4fec1be8b7dd418e9463645ae872ec789ba27b63"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml")
  end
end
