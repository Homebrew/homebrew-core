class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.3.3",
      revision: "41c8128c61e4a8432d802638c5480927091eaf25"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db3ca51c67bc08915f626567466e6d3036802c8a180e314a8d97d825e858ecd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56cfb7fc34adcfd2b0e4d722e670468c66d5ad588d07aad275279b46f340699c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c4cfd7cee429997d0d11f23fd04bed177d778a7ead274d672877afbc2e6589a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86a2ee73a8d3f31176b42ba19114ce554428e0add140643d847dcb7f82f421ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "91de88de238acf7e615cfbc46cf34493e1579c91e6347e580db885ab84bd3f59"
    sha256 cellar: :any_skip_relocation, ventura:        "341818742870cc55f99296e2769fe76228acfcf5242aed9a45b9e01be999e834"
    sha256 cellar: :any_skip_relocation, monterey:       "5672d8fa21495a949671fdaa5f61045519aae08f27d6a8af6b72a493de60b064"
    sha256 cellar: :any_skip_relocation, big_sur:        "98f1e718d7997847fe20e48a4eca3cd4195a2d2f267fb96cab955ffd6e7a6702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e654f502ff9b6bcb0b6e4af4cd6c77de516a82bad53691a0e8fdfcfb5c919e"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
