class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "37516772901d1cd31e7a9655dd3c3f522099f9c0467f3ef886d64301dd8b84a0"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "719d5448ca9017772ec460c7f625bea82fd5a907375bd58ad2a07b3b7396e18a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "719d5448ca9017772ec460c7f625bea82fd5a907375bd58ad2a07b3b7396e18a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "719d5448ca9017772ec460c7f625bea82fd5a907375bd58ad2a07b3b7396e18a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a01c719ab02ec0ca66eaacda19efe97697960ba881be85b15d622b01b3caa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4706f0b4f15463c04498a90168bb19c973e03b73e65d1d10391a9d3985bb33e"
    sha256 cellar: :any,                 x86_64_linux:  "418289bd491051962c37e1325da682c8b128845341518fdf4335a0e8d3b43110"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
    generate_completions_from_executable(bin/"harsh", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end
