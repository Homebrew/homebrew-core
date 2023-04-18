class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v0.3.4",
      revision: "e40c2c72f480e23b33d971185f007ad2e56867a8"
  license "GPL-3.0-only"
  head "https://github.com/anishathalye/periscope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "333a5aa8a2e0355a024ea1778b69195ae74d6dc55d9a531cdf94d65c9dd213df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb703f5a039afb1320ce823bd1f3380d901ad27df0a16d1b21a9536540d0ddfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af13a3dc34d5c9503ada0c6616b4d438abeb7f1328e87540b12895b68f85ce5c"
    sha256 cellar: :any_skip_relocation, ventura:        "5e2e69dfd4cb029246a57c0b227c37f28ac29aeea7533cee1fbbddd80b2d2888"
    sha256 cellar: :any_skip_relocation, monterey:       "18c34f3e8ad43b73e4fe4ab5bc212a515b908fd142a891086333d194b9f29674"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf6c1bc225c635708e7e928093c6d010b08687017166019131789fdaebd48a8c"
    sha256 cellar: :any_skip_relocation, catalina:       "31123f9309c7d37633d5116e4854d2a0e9dc7c36b02290f54fdd2d01613e4a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d5a3b2f1276ef010a250c017020e2737f0298773b270df650581ea514002cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"psc", ldflags: ldflags), "./cmd/psc"

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
