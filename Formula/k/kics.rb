class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v1.7.12.tar.gz"
  sha256 "bf6eafd535a45c49ba9bf934c39ae871c80a82945c77393c3dbc804cae629be0"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fa809f00d8371b826e82f3b5847a402fc27b6ade6918404466e7e7a27fa4b5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71d30cd860b4d37c8db56a6d10e2bd25fcefc3de4285a1056431608d5c2b64b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d1c8aad3d2b8c1bfb143fd57f0c3e8e6f6e233e9476d85cd12ef18a8b7814d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c79421f62b436b5096dff7e0d20192bc5daec3e02f05b9e91f3020ef5f6cca2"
    sha256 cellar: :any_skip_relocation, ventura:        "4a6b3818d598d86b7583fb380e872ae34733273b9643a5088e32ea6878e2874f"
    sha256 cellar: :any_skip_relocation, monterey:       "6de0f26591441e9a62a6a407483021732254e6a4f325ee2309f68d48d27eebc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c202005431e62d8d3962b1ec7ddce289a9adfabbed119565d29d1fdbe65f8748"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Checkmarx/kics/internal/constants.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/console"

    pkgshare.install "assets"
  end

  def caveats
    <<~EOS
      KICS queries are placed under #{opt_pkgshare}/assets/queries
      To use KICS default queries add KICS_QUERIES_PATH env to your ~/.zshrc or ~/.zprofile:
          "echo 'export KICS_QUERIES_PATH=#{opt_pkgshare}/assets/queries' >> ~/.zshrc"
      usage of CLI flag --queries-path takes precedence.
    EOS
  end

  test do
    ENV["KICS_QUERIES_PATH"] = pkgshare/"assets/queries"
    ENV["DISABLE_CRASH_REPORT"] = "0"

    assert_match "Files scanned: 0", shell_output("#{bin}/kics scan -p #{testpath}")
    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end
