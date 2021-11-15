class Amfora < Formula
  desc "Fancy terminal browser for the Gemini protocol"
  homepage "https://github.com/makeworld-the-better-one/amfora"
  url "https://github.com/makeworld-the-better-one/amfora.git",
      tag:      "v1.8.0",
      revision: "71385e9f4e91ab982076856cac95320173ccea73"
  license all_of: [
    "GPL-3.0-only",
    any_of: ["GPL-3.0-only", "MIT"], # rr
  ]
  head "https://github.com/makeworld-the-better-one/amfora.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ec5163a79f6c92982ee1b99657a052832ad92f787e7347571ec3d20f82434f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d37d2bfd27691d2b2a69f5ec5ef94b3af3afbca7fe399dc0af3bb3eec4cab3e"
    sha256 cellar: :any_skip_relocation, monterey:       "3f19f19c2611c9fb2df16c2859d2f6834fdef3b3a86c034d0b90d2f2b555c4b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6701ae1c9412787d6e41e7792b0f78016fe1157948995707b6c41b1b33d0e1e"
    sha256 cellar: :any_skip_relocation, catalina:       "edc5b5c87ac6afe8434e1aeffa9672a17e4ca3ce0b9579c758f27d531c75f146"
    sha256 cellar: :any_skip_relocation, mojave:         "f9246c3f85984e0b1d57daef632186b8e04a2a06350f92ed9562b914e1e80ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34814dc0a1da5f88b639b084ac819fafc2ed49824b28166317bfc9bbce68d840"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
    pkgshare.install "contrib/themes"
  end

  test do
    require "open3"

    input, _, wait_thr = Open3.popen2 "script -q screenlog.txt"
    input.puts "stty rows 80 cols 43"
    input.puts "env TERM=xterm #{bin}/amfora"
    sleep 1
    input.putc "q"

    screenlog = (testpath/"screenlog.txt").read
    assert_match "# New Tab", screenlog
    assert_match "## Learn more about Amfora!", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
