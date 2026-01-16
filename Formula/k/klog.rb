class Klog < Formula
  desc "Command-line tool for time tracking in a human-readable, plain-text file format"
  homepage "https://klog.jotaen.net"
  url "https://github.com/jotaen/klog/archive/refs/tags/v6.6.tar.gz"
  sha256 "78579e2686de8973fba005fcf510e6c382b80c674527ca55c362ed4317897b3d"
  license "MIT"
  head "https://github.com/jotaen/klog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ab3b48dba0abb8cdfd6c3b28e2c83caa69ffa2623a715612a3ebcc5efcbf52c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab3b48dba0abb8cdfd6c3b28e2c83caa69ffa2623a715612a3ebcc5efcbf52c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ab3b48dba0abb8cdfd6c3b28e2c83caa69ffa2623a715612a3ebcc5efcbf52c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c03caffc30d0419f6ce2c531cad8cf66715e71631aeee6457a4e6a3c0c0bbb01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9587564b1ec293057890feaaf927631b6304a19fdde4c8d6bc37bbfa385410f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b828b967c16475108e80dc579901550a8584b8833a523e61f8df051db48231fc"
  end

  depends_on "go" => :build

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -s -w
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
