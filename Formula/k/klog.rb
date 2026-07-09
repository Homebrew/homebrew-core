class Klog < Formula
  desc "Command-line tool for time tracking in a human-readable, plain-text file format"
  homepage "https://klog.jotaen.net"
  url "https://github.com/jotaen/klog/archive/refs/tags/v7.1.tar.gz"
  sha256 "3cd6eee1adc16c2105713718e23b67d9607ac9872a0dbc31689c6051d0176ea6"
  license "MIT"
  head "https://github.com/jotaen/klog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f04bf8b78d72c92f0c708f48d5f9cb11c85b7266fc845874a08ef1d1c566fd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f04bf8b78d72c92f0c708f48d5f9cb11c85b7266fc845874a08ef1d1c566fd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f04bf8b78d72c92f0c708f48d5f9cb11c85b7266fc845874a08ef1d1c566fd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9685c77feb099c5a57f84e4f7ebbfe675354bd9a53b4680bfc20b280a56117e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "085936825f08a8df46e9be28d676e676000c1035e24dadadcf3c7b1a908d82a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6fb17a890a85adbc8829818930bed2aa5910cd8c72b61bc6aebefac7f06817d"
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
