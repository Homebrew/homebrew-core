class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://github.com/mk-5/fjira/archive/refs/tags/1.5.6.tar.gz"
  sha256 "f708f29646a69d371f93bdb09bb5811fc00baa13ab1374bee0719f5b81a6e82b"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5b12f169a54c1ff9d45081cc020f3cea87ac1657341ce667114e2d991d9c46d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5b12f169a54c1ff9d45081cc020f3cea87ac1657341ce667114e2d991d9c46d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5b12f169a54c1ff9d45081cc020f3cea87ac1657341ce667114e2d991d9c46d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b64f13e76f06a159eb6c5db4589a17489ffccb9ec3f3e8555c6d4592826f1f37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b60fc25b5137b28fc2087a8da4074c1c1cd4d647f3da84c54240ef49663dcbcd"
    sha256 cellar: :any,                 x86_64_linux:  "f3d9e71004c9cf52109cd6ab22bb673c0ae9af112563c1e407dd4ce59a2953db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fjira-cli"

    generate_completions_from_executable(bin/"fjira", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fjira version")

    ENV["XDG_CONFIG_HOME"] = testpath

    output_log = testpath/"output.log"
    pid = spawn bin/"fjira", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Create new workspace default", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
