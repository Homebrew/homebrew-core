class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v0.3.4",
      revision: "e40c2c72f480e23b33d971185f007ad2e56867a8"
  license "GPL-3.0-only"
  head "https://github.com/anishathalye/periscope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d28b75517b42896ff457c615829d23ecb79cd2f9153a13d7124c329847a4cc03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03bf29533f7d9f46900524809f8009986f67c1f90822356993be0ede9bff9ea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91f3df2781729b7c46379b5a3c0c71676ad6179433bc0e468b4a7f937a89a4ce"
    sha256 cellar: :any_skip_relocation, ventura:        "51f92677112390647a7b29daa9938212395493ee2a4e8346d92a6567b2a4649e"
    sha256 cellar: :any_skip_relocation, monterey:       "39566bc444e1630d45949e072a821840f81bfaab0c396fdc7d5cbaef3c60213b"
    sha256 cellar: :any_skip_relocation, big_sur:        "890bad3c2562832d130a80a5510c07ec59debf8a8f4b8abd5513ea71b3eecc19"
    sha256 cellar: :any_skip_relocation, catalina:       "46005f95891f9594cefe1aa56c18b5c6103698365f07095decd2b1cc874f703f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a311ecb06e2fc0d8341c01fff9e2c0cfccea6a8d6593b6865e763b27603af557"
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
