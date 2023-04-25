class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.16.1.tar.gz"
  sha256 "307996fa49502c3edfb231827a2b8615611000b35bc2bdb913d5433279ddf067"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e4738c6eb91aa0eae7e352080a7b77204efc62d9a4be6f616ddbe3b269d3b54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e4738c6eb91aa0eae7e352080a7b77204efc62d9a4be6f616ddbe3b269d3b54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75cd109c5fb83972920b6bc1d29219d7113bcf9e1add53769022d75e8eca295d"
    sha256 cellar: :any_skip_relocation, ventura:        "d8b72e10c5ff936e417867f9cc264bebbeeffa3f169ba4e21538d8cb92150037"
    sha256 cellar: :any_skip_relocation, monterey:       "fdfacf74f6d5c97751208e131d71b427a6969f26cf6988b90084094ed7cdd1dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8b72e10c5ff936e417867f9cc264bebbeeffa3f169ba4e21538d8cb92150037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6b40e794fde59f7b0bd8ebf7c5deb197d4fb6b2d8870b2aa5dc33ca13d3c668"
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
