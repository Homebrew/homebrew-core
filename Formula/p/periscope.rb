class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v0.3.5",
      revision: "b4eb74e389a3bb4eb6a4225e9bccd8744203b895"
  license "GPL-3.0-only"
  head "https://github.com/anishathalye/periscope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ab01d2a319b29ac06a55323a47b3b7b336123add4050abdbf1d616e97a79cc97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95317b64f7df0f4097e72d44efbb4660f1efa74fd1903e79820f734a83b23738"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1814d4eb64988e0cc57a7766b0696c55ded99437a3558d60764f2c85b5e1cc53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e2100139c6388a7954e002f8c40415b01bf5538e266ce057d2635771a2e85f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50a953e087342698678e7d6f91f1b0efff98ccb25dde5896f210f073def24e41"
    sha256 cellar: :any_skip_relocation, sonoma:         "61becf54c83893ae5db8a69198e97e56b868e1d36af3405307a6fe5571c0b847"
    sha256 cellar: :any_skip_relocation, ventura:        "e71b0d0433581720f9578bd744886f365683a40eda9315e01a5ceb925cc75d02"
    sha256 cellar: :any_skip_relocation, monterey:       "3e2b016f5a54f9a6706ecce39590612016763ca8a28cb362736b943b4d18d7f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "52c225ce532478e5e002ac925312006dc0d6a29ca96ce04a1953df796728ad31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99f72d97940f3463403ab50742b48f2a7c325a761cbb278c500c9fe77c07991e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"psc", ldflags:), "./cmd/psc"

    generate_completions_from_executable(bin/"psc", "completion", base_name: "psc")
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
