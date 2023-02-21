class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.13.4.tar.gz"
  sha256 "139cb20643a56e957daf06287d21d79a2f1b1d79b8194292bdadab07afba5f57"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb93568d666edf33ab4bb6000365992192cc766f12b297c49ceee7618a57dc1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dfc23777c80ba7a7a93ba396347431b7360e706554d16366f7fb2742c3f0229"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec7e408f0d020187f0f035d273ec79e511d314f4d309576d44172efdba10527f"
    sha256 cellar: :any_skip_relocation, ventura:        "cbc995a61539263e4e3b17d036d85cb042a297f36b854cd5fdc1da6c7cbf333d"
    sha256 cellar: :any_skip_relocation, monterey:       "374c799f6fdba538a4d7fd369a708a42c9d568bc7bda5a40d490c2121a72e139"
    sha256 cellar: :any_skip_relocation, big_sur:        "d99be84f58dfeb4b852938011d172067a5a61cf60f506fd5ddc3ab69ee8e80e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd7ba134bcec27b68365d9afba0584e8dcc51a856dca70a2d59c449f5a71b3a1"
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
