class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "0c7d300b6a3deb22047e3d98548c4abcd87d23fc53042bfdce27a458582711db"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "160ba184eb4d0b1b793d196cdaf21c33a03c41cef5540023379204b540086c83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c38e2e440852635589944dce7e6a4d8e53d753bd468d22992433810e0ba63e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae5e2af9c257731b9375d5c603cbd7d9c260fe6fa0ec116f042e5f950dfc7889"
    sha256 cellar: :any_skip_relocation, sonoma:         "6609c7629c61a11f2a5530b4e7e6a622a6e9210b31d2559382323feb199e1f5d"
    sha256 cellar: :any_skip_relocation, ventura:        "001ffb95fb090479ddf6cf783af20c3e9cb98b8c854a349ed96524122fc97c78"
    sha256 cellar: :any_skip_relocation, monterey:       "fc45d079ebb81891ece05acb37589ee3295a992b1ee0054337b6013a92d3ba1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b74cc3160ca344fc02cf457344e2b111688f8c0ec6b61ab23730b6a3d28612f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/glasskube/glasskube/internal/config.Version=#{version}
      -X github.com/glasskube/glasskube/internal/config.Commit=#{tap.user}
      -X github.com/glasskube/glasskube/internal/config.Date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/glasskube"

    generate_completions_from_executable(bin/"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
