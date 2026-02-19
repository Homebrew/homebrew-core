class Klog < Formula
  desc "Command-line tool for time tracking in a human-readable, plain-text file format"
  homepage "https://klog.jotaen.net"
  url "https://github.com/jotaen/klog/archive/refs/tags/v7.0.tar.gz"
  sha256 "4f0a87eb65eb2ce047ba05af0c03cf84deba142b0f2eebcf5d4614f6351d6489"
  license "MIT"
  head "https://github.com/jotaen/klog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9a991f938594ae7239be3146cf3e434c76ce0e77dfe8af79db376a8e5e21fef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9a991f938594ae7239be3146cf3e434c76ce0e77dfe8af79db376a8e5e21fef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9a991f938594ae7239be3146cf3e434c76ce0e77dfe8af79db376a8e5e21fef"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4ff7f2c9e752ea6ba7ed016fd119ff37d58d19538e803f24d3b6c963f4fcf33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89ca8b1842fb2f4d4e485fc6c387acd0306ad8c073d57bbba64d0e0a82efdf36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cab271e9e7f45f308cd783309ee2b02a70bad752bb17e4c87c8a98543619bbb4"
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
