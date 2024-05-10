class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.7.0.tar.gz"
  sha256 "1ebaed7746d01aea0e64a9857634c520f963de230f84411aaf191a27ed352d6e"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d50c5640759a9575c9ecacd0941d22bf0b86a0d6b5f33f1650313a8227d98c52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb8e75e17c9601eba6fee6adfe9b5a3b951ea3cb9057f9c3ffd71c186a608efa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f9fe23b22e741bddc8e3e0035ad5377c6e1b64e72c980aa7c2bc2a0c4b3b6cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9513b9e21ff7d2ad0593952a0936d6bc1ffec9f67ad8300236979ebab4d371e"
    sha256 cellar: :any_skip_relocation, ventura:        "f249a49df8b6f130acfb49720bf4a58de4adc894bf9fdfa0fa39fd29ff042e94"
    sha256 cellar: :any_skip_relocation, monterey:       "19144a0567df031b8c5b3807b4b46a53ab310658cad7aa64f90f46cd04447a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e51315dadf9fc1b0e14fe2a65877c86213a3f2ddfb930e6d0dc27797720a892"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end
