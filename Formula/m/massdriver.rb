class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.10.7.tar.gz"
  sha256 "fbaa8281509139d83b64f10a8851630242cd1648a2437b4be38c0e9e39e87775"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7114dc9c2b595a774f1c445a69d51148301c25e33010d4657ac041b2156b56a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7114dc9c2b595a774f1c445a69d51148301c25e33010d4657ac041b2156b56a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7114dc9c2b595a774f1c445a69d51148301c25e33010d4657ac041b2156b56a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ee801a50cfa9434d2c50152ac985fdbcb69a0aad4a1786312ed31f08a054609"
    sha256 cellar: :any_skip_relocation, ventura:       "6ee801a50cfa9434d2c50152ac985fdbcb69a0aad4a1786312ed31f08a054609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0a66e63f10ba634f78cce3b411070652425fea60f61965c08aeffa74d1cc353"
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
