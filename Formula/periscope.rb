class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v0.3.1",
      revision: "e434390fbc41345083b8cfe3d65c743b3299de06"
  license "GPL-3.0-only"
  head "https://github.com/anishathalye/periscope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee724c8be393c6f09fb3d4d68091cfdc51ff1a1647391a9a53c901ee9a0f050b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a316061e8574f8306a0db428030a80b1d881fa01f44d3fb5e11fbf262eb005dd"
    sha256 cellar: :any_skip_relocation, monterey:       "9a1e52d7026e676bb53e8c8f11d4a93523d8b8a698a3225f33dcc71de215f02e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce293d18056b44958098f6950986676ba6747df28fda897ef6f7f9e83c19b724"
    sha256 cellar: :any_skip_relocation, catalina:       "b27894c43a915698a3667d5c77ee120e097195bb42f039ad12fc8aabb684f168"
    sha256 cellar: :any_skip_relocation, mojave:         "175b7fa2671aa807ae3574326c65efec9e2ec7599ce4645ffcbb4ee4b3b14056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2998259acfde7a53687bf3f46df9c7258cefe94ee1a7a6e5bfca3ed187f969c"
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
