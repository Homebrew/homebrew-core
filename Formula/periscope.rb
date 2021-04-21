class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v0.2.1",
      revision: "00d8e6699a9f5037c5f0d3f8cefadb14b4321562"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62bcdb7e1d0a230a65fdd16b2a9e9b34e5bd676b8e6c661b2bbc5deffca9a0d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "24aefb91809223a004545b0f7966851a4c01cfeea1928afd7229aa4f0c31a343"
    sha256 cellar: :any_skip_relocation, catalina:      "c61ca7e7e40bbf7b6f20f31666eb524880cbcdd8044f2acb676169627a1f4c01"
    sha256 cellar: :any_skip_relocation, mojave:        "fd07096a5c2096d16223fc292be0a3ccf0f1af1f59619ab14938c9ac30890ebf"
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
