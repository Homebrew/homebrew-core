class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v0.3.2",
      revision: "fc3a56637217d55014189c43e76c58ceddb7bfc4"
  license "GPL-3.0-only"
  head "https://github.com/anishathalye/periscope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c083f344567284d8e4891a18972912fe584d1999630189b74e438918f7d723d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aecf97a48bf9e29cda56583b368bf493acd62028c2b3b402a1a0e235325aa25"
    sha256 cellar: :any_skip_relocation, monterey:       "e7516460bfab724ebd80fc8f9264d4e8e97a51ba899f3eee15f88988551626dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "10c81131c0bd4d8c9539fca14337dd0d1c48c4ec71c71429d9e33be11bb9c558"
    sha256 cellar: :any_skip_relocation, catalina:       "438188a058d3f4a04fb8e2fedc23e331ce709d30f8f18a7b40c8a187789a5720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "349a1ec5f485892797a8734b5b1c0eaffc1722b2980c168795cb9d7ed7ba1ca5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"psc", ldflags: ldflags), "./cmd/psc"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"psc", "completion", "bash")
    (bash_completion/"psc").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"psc", "completion", "zsh")
    (zsh_completion/"_psc").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"psc", "completion", "fish")
    (fish_completion/"psc.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psc version")

    # setup
    scandir = testpath/"scandir"
    scandir.mkdir
    (scandir/"a").write("dupe")
    (scandir/"b").write("dupe")
    (scandir/"c").write("unique")

    # scan + summary is correct
    shell_output "#{bin}/psc scan #{scandir} 2>/dev/null"
    summary = shell_output("#{bin}/psc summary").strip.split("\n").map { |l| l.strip.split }
    assert_equal [["tracked", "3"], ["unique", "2"], ["duplicate", "1"], ["overhead", "4", "B"]], summary

    # rm allows deleting dupes but not uniques
    shell_output "#{bin}/psc rm #{scandir/"a"}"
    refute_predicate (scandir/"a"), :exist?
    # now b is unique
    shell_output "#{bin}/psc rm #{scandir/"b"} 2>/dev/null", 1
    assert_predicate (scandir/"b"), :exist?
    shell_output "#{bin}/psc rm #{scandir/"c"} 2>/dev/null", 1
    assert_predicate (scandir/"c"), :exist?

    # cleanup
    shell_output("#{bin}/psc finish")
  end
end
