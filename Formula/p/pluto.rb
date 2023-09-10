class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.18.4.tar.gz"
  sha256 "680a475c85774db90de310a883bfb3d1ee374074ff74061315c1b50a006fa2f0"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "360bf714d3e82e8f38bcb129d44c8e1b3e395f8778557432d59327180b3f893f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c0c004b727144b2a9ea42d707d5a5cb96c6e71c16d367a699edc1c6841afea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad4a529d51cd09a5f5270a1274218134ce336c3cd0164bb4ef61578afbc9d183"
    sha256 cellar: :any_skip_relocation, ventura:        "a3a15d1e797e3fa9a3a9132891d87d5c12c14e2bd5a0076d687476042da7ce2f"
    sha256 cellar: :any_skip_relocation, monterey:       "aa27bd984ab6987cc55f4531c8eaf6843e29f9ad88bf0da325a71c4e7a4d454b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7d6ef474db1ed985f196116d691d2f2b1ee651208f32653805301de94aca3cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3c44410c7c46ca818609ad8e2b258bed02036965920720f941981ba05a4b8ed"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user}"
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
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end
