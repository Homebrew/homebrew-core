class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v0.2.2",
      revision: "ff389f2a52052b1a936921e1f5b30d36eaa961a1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72e43c809a0ab076c14f88532734dbd1919e68f27384881ccfcff6cea70f5adf"
    sha256 cellar: :any_skip_relocation, big_sur:       "828885390e0a645535dd613e3ae2846a89799bdfd21e74434507915dc7d81017"
    sha256 cellar: :any_skip_relocation, catalina:      "f2022e8c77ecb2562f19ebce673618ec83b3fdbfb8722709309d30f64af883ec"
    sha256 cellar: :any_skip_relocation, mojave:        "213d6d28aa466e53523a4c5542122387461644d7488f1353ec10fc2cb091b46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db8ead8af19fb810633bc664c97360d607769dbdc5d3dc6ee23baa7773ad993"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
      "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head}",
      "-trimpath", "./cmd/psc"

    bin.install "psc"

    # install bash completion
    output = Utils.safe_popen_read("#{bin}/psc", "completion", "bash")
    (bash_completion/"psc").write output

    # install zsh completion
    output = Utils.safe_popen_read("#{bin}/psc", "completion", "zsh")
    (zsh_completion/"_psc").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psc version")

    # setup
    (testpath/"a").write("dupe")
    (testpath/"b").write("dupe")
    (testpath/"c").write("unique")

    # scan + summary is correct
    shell_output "#{bin}/psc scan 2>/dev/null"
    summary = shell_output("#{bin}/psc summary").strip.split("\n").map { |l| l.strip.split }
    assert_equal [["tracked", "2"], ["unique", "1"], ["duplicate", "1"], ["overhead", "4", "B"]], summary

    # rm allows deleting dupes but not uniques
    shell_output "#{bin}/psc rm #{testpath/"a"}"
    refute_predicate (testpath/"a"), :exist?
    # now b is unique
    shell_output "#{bin}/psc rm #{testpath/"b"} 2>/dev/null", 1
    assert_predicate (testpath/"b"), :exist?
    shell_output "#{bin}/psc rm #{testpath/"c"} 2>/dev/null", 1
    assert_predicate (testpath/"c"), :exist?

    # cleanup
    shell_output("#{bin}/psc finish")
  end
end
