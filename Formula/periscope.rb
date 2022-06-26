class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v0.3.2",
      revision: "fc3a56637217d55014189c43e76c58ceddb7bfc4"
  license "GPL-3.0-only"
  head "https://github.com/anishathalye/periscope.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "175e53a44e0d7b52db436369d918b12e34dbd244ddf7ba40e19c4e85cec2628f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c882c0377cff2389da04d004674e157d8f71953a0142a4b334d95518e957e96"
    sha256 cellar: :any_skip_relocation, monterey:       "f3bac4b5d15200c10954a2113bd4ca3c3105a614aa3c605b158d11b048daa317"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9e56226deeabf9615a15af87a7ba702a9292eb3f6be1efbdae16245f51eb3af"
    sha256 cellar: :any_skip_relocation, catalina:       "e60a33d406582d371f3a0bbd2f4ad78f9da9c4bab998b695a6a1b9e6baa29312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3404970d8676e0b7d6391c92631fcb720c72b704833467d883f48558746efc92"
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
