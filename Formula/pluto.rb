class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.16.4.tar.gz"
  sha256 "64aa6d2c98a71875192a868592481e41240c4ae3a157523da9cbe18ed6bb0ccd"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63d0c7634f0ac5aaccb984fddb6f25993f24a849497468bef9cda12cb3b58eba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63d0c7634f0ac5aaccb984fddb6f25993f24a849497468bef9cda12cb3b58eba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63d0c7634f0ac5aaccb984fddb6f25993f24a849497468bef9cda12cb3b58eba"
    sha256 cellar: :any_skip_relocation, ventura:        "f05ea8b09ea19146eddd8a7af659534428795e5aca64f7ec47a4f2869b20f3e9"
    sha256 cellar: :any_skip_relocation, monterey:       "f05ea8b09ea19146eddd8a7af659534428795e5aca64f7ec47a4f2869b20f3e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f05ea8b09ea19146eddd8a7af659534428795e5aca64f7ec47a4f2869b20f3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "438883e70cb85b525444b2801bd54e12775b6b3613ae40bb574b9d3e67de1dd0"
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
