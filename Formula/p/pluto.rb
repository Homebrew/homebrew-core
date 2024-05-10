class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.19.4.tar.gz"
  sha256 "eef237b1f7900cf369267b11f1d49296a6f0c0e26920772e94aed2ea4e0aeedc"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac01bc4d6d66050afbda05c70e74c6a651d5d99c93cf5b8fa7a23ca97cef037c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4f2e197139e0b5f73565e1c7368e62b8cf25e1805fc36326f82d422a56b0c82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54a45b5f9f31aabd894eeaa408ec10f025af7bda397671a0bc91d44106ac2407"
    sha256 cellar: :any_skip_relocation, sonoma:         "2798bac2e4b3378ad6becbcbb0d03e2fe7a74ce6aef895d0055e6b01d4feee04"
    sha256 cellar: :any_skip_relocation, ventura:        "a6648e905b7493bbadd8a1ef41ce0e77503b7d659ef8351157bd75cd38316ce7"
    sha256 cellar: :any_skip_relocation, monterey:       "1d244d60fdfe1624b97a501396c4dec0cb3fde4ecce42b71d7fdef861506a826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2de92499b63d3935a47f717d67de1441ffd5557259e76ef40a76fe187a97d5f2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmd/pluto/main.go"
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
