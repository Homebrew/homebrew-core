class Kconf < Formula
  desc "CLI for managing multiple kubeconfigs"
  homepage "https://github.com/particledecay/kconf"
  url "https://github.com/particledecay/kconf/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e7fe6750c719caf227890a31e2fd5446972ec3e1e5492180d0a387fe1c3394c0"
  license "MIT"
  head "https://github.com/particledecay/kconf.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "716e365025812d14fe17774fc209d18cc8f37aeae47916525f4a1547797e12a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "716e365025812d14fe17774fc209d18cc8f37aeae47916525f4a1547797e12a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "716e365025812d14fe17774fc209d18cc8f37aeae47916525f4a1547797e12a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "848797af83206e5beba36e0796a0627a87ebf8821753cfaf11d2f4a916fa8aec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f003fc02c549d3c6963af7c0a455bdb796147ddba2d66aa0bf5c2be3458082f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "847f19228e51932af6b6ca5b484c82fc5e5b0baf62d54189333cf5f45e2fa6fd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/particledecay/kconf/build.Version=#{version}
      -X github.com/particledecay/kconf/build.Commit=#{tap.user}
      -X github.com/particledecay/kconf/build.Date=#{time.iso8601}"
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kconf", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kconf version")

    output = shell_output("#{bin}/kconf namespace homebrew 2>&1", 1)
    expected = "you must first set a current context before setting a preferred namespace"
    assert_match expected, output
  end
end
