class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.15.tar.gz"
  sha256 "ef320d40190c2fa80f0da30f405a8e0557ad32c70116952a57c7a90ea1e66fc2"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0174d64d8d4500da6d8e6bcbe423b5df7293a0efc33c58e498e6c35cd73aa971"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "008558ae2c969a7a15faa15df610ace382b4b983c6f966d6fbc4f46077f3e0b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15e8b4b34027f9546b6ff348e4673c673e31833c6ac1474ce86c6893e32acbd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfce73f3ad6f7214f426ffcf1189b4306c2e440a9ded7e06f0fcbc63eb3cb1a2"
    sha256 cellar: :any_skip_relocation, ventura:        "960443b266523b8a82c089ba46438b767d168d2a1f947a0fe29a97d06abb7547"
    sha256 cellar: :any_skip_relocation, monterey:       "384b6c3afb487b24c7cc36d00246a564f9af2406c0fe208096879c117acb5300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e99e9a0340d5ceb52fd3f069c4eb967282484938456ece4cb3693657e10b637a"
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
