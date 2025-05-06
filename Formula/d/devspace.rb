class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/devspace-sh/devspace/archive/refs/tags/v6.3.15.tar.gz"
  sha256 "9026064ed3ede1c1214ca1fa58e64379a7679bae6d00d32847a216d13960f498"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef4d6538faf7cbcdf5e082b6c1e7b2383f6026e4d2d0dd8868dd7d32794bbac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c67ad1139eb728437d2ef33176abea6e84df6287d0093781c2e4f8cbad01654"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f0e716dd00a472b69723cc700f66d4937a1c770b78aeaf04d2316d6970e1448"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae9b0e8033c854dbc3dfe746c563adf0bf39b99e60c00131261ac805df910ae7"
    sha256 cellar: :any_skip_relocation, ventura:       "b35af98d07349b71630e0f2cb0bd87fa231bc2058ca519e087599b30fddf58c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8602287611d26cfb6e820739c4184dabaa91e86ff4f797bc39795357be3c0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7cb388594525cf14b8f36560ac0becb2ff284b71b1547ebff46d9bda6fa2ef6"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{tap.user} -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")

    assert_match version.to_s, shell_output("#{bin}/devspace version")
  end
end
