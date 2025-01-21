class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v1.0.0",
      revision: "3d398cb7c9d8e41690c54371861d1b0a0119c485"
  license "GPL-3.0-only"
  head "https://github.com/anishathalye/periscope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9640cda5271196d7ae0b4ec8fd4aac56378bf70a89529dcae21995c9bb53ab36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2c4e1a39fe80211258e6269f9ad212d261519b223e89f1f0f93f84c64f18d00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d3a14af2b8bbc5def8dc556de099ddb30f2c4f129743ddfde14226af0f2397a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a2d6787de19316613a10a7c2e1cc921047575b031ac6363e2dadf9425e91ca5"
    sha256 cellar: :any_skip_relocation, ventura:       "2eef76919c4d079f13b3f67dc36c45e24b64daced55875b33d3537fdaee34c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730c36044c98b82acf32c59bb4137e3b572970e0b8bd0d05198f8bd24d79ac83"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"psc", ldflags:), "./cmd/psc"

    generate_completions_from_executable(bin/"psc", "completion")
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
