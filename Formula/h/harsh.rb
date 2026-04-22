class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "b4f03607930bc64c52e7c10e4df7e4795bdd9c840bd5a57b5607a36bfee021ab"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "369d71cbc7ba4c5abed0f420c5554dd5009dc755374f0068971d2c0bdfc1d75c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "369d71cbc7ba4c5abed0f420c5554dd5009dc755374f0068971d2c0bdfc1d75c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "369d71cbc7ba4c5abed0f420c5554dd5009dc755374f0068971d2c0bdfc1d75c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a9db9ca7a098119b4233a8be98f1635f829929a232bcd4d732ee0f84f0bd01b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0ada6c16a39cf1c1ff6b024fee9947da751b5b485003c1cf27b7eb557b23acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1707c89d975668232452de5040916f800543bfcd6fc182ae71dbde7c6682eea1"
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
