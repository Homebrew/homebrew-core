class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.22.5.tar.gz"
  sha256 "b73b246f2cea3587b6ed4461be963d3ccff42d0311eb551e4bcb796038ffe785"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2ce8542f9844379316b832ffdf2be851fcbda2b71d6e902c9acb9026c56be3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7e0f503c5794de3102e4a5c76f8dc68fc0b49c15b7e3f7c9084077cc62acb84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7e0f503c5794de3102e4a5c76f8dc68fc0b49c15b7e3f7c9084077cc62acb84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7e0f503c5794de3102e4a5c76f8dc68fc0b49c15b7e3f7c9084077cc62acb84"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcdd8707e83c45429b3f9da5da45c2368854703e4dfa417eae281e3e417998c1"
    sha256 cellar: :any_skip_relocation, ventura:       "dcdd8707e83c45429b3f9da5da45c2368854703e4dfa417eae281e3e417998c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14e986cc7bc813da8d483d34e9e813557f11616b07a20a5c1d1c9e40d4c8537f"
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

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    YAML
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end
