class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "605e87f4d566f14455f6c1e609eabd3fc2337a09d695fafc489011ce48b02035"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4711592a6b669b5d417bf261032b49b16a0939ccd1af8d0b72bf09eff8875988"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9517c8459dbd5480f9c0d20230d1a331e22de9225109d0b777fc9c438fbb366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9517c8459dbd5480f9c0d20230d1a331e22de9225109d0b777fc9c438fbb366"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9517c8459dbd5480f9c0d20230d1a331e22de9225109d0b777fc9c438fbb366"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f5d4e0bcadb62fd9c54073b4868129f67bb484189800987c64a663a6b594a49"
    sha256 cellar: :any_skip_relocation, ventura:       "3f5d4e0bcadb62fd9c54073b4868129f67bb484189800987c64a663a6b594a49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b19d3cb0925d0cb510b6a5fd8e0fb277309db68a43bda6e6687cb474b6e0e734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2acf192f12d0435f4d764e2fccd9a532b708ec0bd24cfc2d4b7a0beed3840c2"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end
