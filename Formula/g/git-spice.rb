class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://github.com/abhinav/git-spice"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "fd0b7768339fe6ca113d6e89a80b8d4f9f3ece38f20073312dbfeb62dd7ccf7a"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44366fc17e25b88bb81c0576ab93063391ee4a72dc9fbe82d74db49b3b6e458c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44366fc17e25b88bb81c0576ab93063391ee4a72dc9fbe82d74db49b3b6e458c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44366fc17e25b88bb81c0576ab93063391ee4a72dc9fbe82d74db49b3b6e458c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf8a1490342799075d209e5c58d08bd7756d4434843e01c3ccc4516391ea9121"
    sha256 cellar: :any_skip_relocation, ventura:       "bf8a1490342799075d209e5c58d08bd7756d4434843e01c3ccc4516391ea9121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d519483d46e298f6b7b69eaa880c7a77d0fc3d88234f78c3cb239633938a1389"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gs")

    generate_completions_from_executable(bin/"gs", "shell", "completion")
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}/gs log long 2>&1")

    output = shell_output("#{bin}/gs branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}/gs --version")
  end
end
