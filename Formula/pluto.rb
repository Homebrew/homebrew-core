class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.14.0.tar.gz"
  sha256 "29de8d9af681c073f67079261c486d148cf5c0e7df6060fcecdc687e2700df46"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ada2614d0f5f0202bd794b3de3d0ca1abb1df463c3df6f645b9613a2f03bf588"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d89b425314d78c3175608bb5fec215fa13abc4a020574237a5859b287d13303"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90675dc3176db8e97f400fe8dee3a5689873ee83732f78e7c315595e5c8778e5"
    sha256 cellar: :any_skip_relocation, ventura:        "9786e48da56b4771a0dc6cc43e51a55b12eb1c2d5d103e3a7b8aee7b4715eb64"
    sha256 cellar: :any_skip_relocation, monterey:       "1220fd3bfb0e42a1c5cedb05c61ddd4d9980aaa5a0c37ff6d54d672783b2e8d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6a6074795d38423944911ddb8835a2922f9ae1a17ef3e900b86051b2a2bc104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "989dc229f2aee3963acd49e5d592e4443976e6bdb2851c9a3ff9d5d89dfee750"
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
