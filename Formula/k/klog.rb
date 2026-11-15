class Klog < Formula
  desc "Command-line tool for time tracking in a human-readable, plain-text file format"
  homepage "https://klog.jotaen.net"
  url "https://github.com/jotaen/klog/archive/refs/tags/v7.2.tar.gz"
  sha256 "a11f6eb447103d9f77e02cdb37ea7fe77910835c1786f45b1760252e86672317"
  license "MIT"
  head "https://github.com/jotaen/klog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "392b4b7a819fa3f60bae2e65a25db261fb8ba140936698d24097cc56cebb68d2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "392b4b7a819fa3f60bae2e65a25db261fb8ba140936698d24097cc56cebb68d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "392b4b7a819fa3f60bae2e65a25db261fb8ba140936698d24097cc56cebb68d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c4b9de0a3d9bea90c72dd928863bd7be857b8d6a974f5dc34c1c96cfefc3a54"
    sha256 cellar: :any,                 x86_64_linux:      "16111061c4bde6d5c2125094ba163a4d86eda45ea6441a957aca92a12cc9dc30"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -X main.BinaryVersion=v#{version}
      -X main.BinaryBuildHash=brew
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/klog version --no-check --quiet")

    (testpath/"test.klg").write <<~EOS
      2018-03-24
      First day at my new job
          8:30 - 17:00
          -45m Lunch break
    EOS

    assert_match "Total: 7h45m", shell_output("#{bin}/klog total --no-style #{testpath}/test.klg")
  end
end
