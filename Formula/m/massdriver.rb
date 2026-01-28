class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.6.tar.gz"
  sha256 "44e24b8fc930ace0454216dbf968b3128c3c11c3f55416366f4abab67eb42cff"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bb8856e43d361a8a4f46408261d0f70b4a960df82b6d13d64026a83295d8097"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bb8856e43d361a8a4f46408261d0f70b4a960df82b6d13d64026a83295d8097"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bb8856e43d361a8a4f46408261d0f70b4a960df82b6d13d64026a83295d8097"
    sha256 cellar: :any_skip_relocation, sonoma:        "0163c917339e9820687bce602d580ef6fb5cba45b1858efc31b90912cd5c8034"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa2939079fa6700769653d556d0fa2fa92a4e3017b26cbc9e86cc5a3511f0740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a5c8f1e1e8bc15e634e42d5bab1b2e826feac03111ff3383444f5d7cce4d121"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
