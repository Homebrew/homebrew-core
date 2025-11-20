class Fjira < Formula
  desc "Fuzzy-find cli jira interface"
  homepage "https://github.com/mk-5/fjira"
  url "https://github.com/mk-5/fjira/archive/refs/tags/1.5.1.tar.gz"
  sha256 "8e7a8879f5d763e22777732151b3439700f2d46c6bc26c24217288eee280ddc0"
  license "AGPL-3.0-only"
  head "https://github.com/mk-5/fjira.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02365ec7055f9d1bdfba6904876d33057c40583809b4db614d05167324f44980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02365ec7055f9d1bdfba6904876d33057c40583809b4db614d05167324f44980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02365ec7055f9d1bdfba6904876d33057c40583809b4db614d05167324f44980"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c12704eb8bb53fa763640b8beda47b678258f674b54774fa0b582cd6e605ed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1847eae3b1f756555575179ceed091c3722e6510063e4e9f5a8339b2292c8e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4b055a14b8cea6ef9e126baccec3911e189d701fee0ed85045134408c4561a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fjira-cli"

    generate_completions_from_executable(bin/"fjira", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fjira version")

    output_log = testpath/"output.log"
    pid = spawn bin/"fjira", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Create new workspace default", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
