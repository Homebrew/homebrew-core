class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.12.3.tar.gz"
  sha256 "f3a0365c59f38655f08dc7165bb80591ea199e3c586d546aaf9b45e8930a029f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa22709bd25d167b9191d7fa251f9a70686e0a5d970010ad36ddc115b37b5731"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa22709bd25d167b9191d7fa251f9a70686e0a5d970010ad36ddc115b37b5731"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa22709bd25d167b9191d7fa251f9a70686e0a5d970010ad36ddc115b37b5731"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa22709bd25d167b9191d7fa251f9a70686e0a5d970010ad36ddc115b37b5731"
    sha256 cellar: :any_skip_relocation, sonoma:        "c09572b599fbb3fdf2372b33d9fc27864a40ec4c2038ae76e03f229b46c4fcd6"
    sha256 cellar: :any_skip_relocation, ventura:       "c09572b599fbb3fdf2372b33d9fc27864a40ec4c2038ae76e03f229b46c4fcd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e308e44063ac23a97bb179b8a8cfe683deca7dad8187dbaa84fe66e27ee61b53"
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
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
