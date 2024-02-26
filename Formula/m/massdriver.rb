class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.20.tar.gz"
  sha256 "ad34447e7f298bedbb43ff91723cbb81e380b9e750c4fc39f58c3d135af44d69"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d82377d2f2384881fc3cc97fb21deb8f137757ce7532a87e52f5d05f4b26b999"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80af317723482a2cd68e2ad240a9a3697212b669fe81ec82f050238eff1f93dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23408284e46975f7cafc3e55cb53c78a2617d321fbfb5499077909e486c4cf79"
    sha256 cellar: :any_skip_relocation, sonoma:         "be55b73f05c354bd6b38c79438290a80260f812128e42c8f31966cb16370a94f"
    sha256 cellar: :any_skip_relocation, ventura:        "fbb5486a8cdd77d667e0c641b08b151150668161476ad73f53ab8996e4d10cb9"
    sha256 cellar: :any_skip_relocation, monterey:       "acf316ffa5450a9ddacdcf36cc194d8f9665d10af1f08ad9dcf484e217250ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2881b86cae994955105ae55166bcd1c3df7cf49e127fa0a9b5debb8ccb61ffc9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
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
