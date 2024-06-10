class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "b8d435bc8138914ffe7229900f7a102492b967b8282ccd2d677b1ce65e84687d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e6c354a846482945d28b3af474a7b81672b44e461cf00ab85efed811868aa1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96daf19db88a4445b872f42087019469ddad3e39d5aa3a402378524e464a5de6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79f42139e6a9f390accc925eadbe8253fee1eba4e84f26be14af2cdad116e034"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b3591c3759adbfd011d384006eed8fa0ec456e3b9206f92640e9f17516b64af"
    sha256 cellar: :any_skip_relocation, ventura:        "a7a261afa4fbfc90c555bfb151740d2937946f57c7a4f12728967fac12da5b40"
    sha256 cellar: :any_skip_relocation, monterey:       "99aad8e3e05e9e1e9dd5859509d4c11e0b597cbcf49a0efaff58c9309dc0127b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d29e6978219ca06b85f84e90fa751f55b23f37a4bc93bbbb18a92a50290fe742"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
