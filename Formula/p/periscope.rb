class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v1.0.1",
      revision: "a279bfd38e6ff8f4730e52fc670d8e24b98eda7a"
  license "GPL-3.0-only"
  head "https://github.com/anishathalye/periscope.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3189320a2bd3be0f1919621582743539f0af9915a92b26c2d4e95dc43466dc21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c40e9cc889cfec650492994dbe0e5a9a17a9755f925bc73f904dd0844801fccb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f9fa628d7186231bf8115aad5b52202c36849701479b555742c16ff846227ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e3e839701f4e03c35810ccbbdff7a656e0c378bd41aa45bd3043b05c9b24878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "345da8c73fe8c8f7a7be4162ada3b06ac3c7bb5dcb713e901175867a6ea8b19a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abf9ca3d7a4b3289def2009de76d1a93969011bdc3dcd344845fe3fbc9ca69ca"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"psc", ldflags:), "./cmd/psc"

    generate_completions_from_executable(bin/"psc", shell_parameter_format: :cobra)
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
    refute_path_exists (scandir/"a")
    # now b is unique
    shell_output "#{bin}/psc rm #{scandir/"b"} 2>/dev/null", 1
    assert_path_exists (scandir/"b")
    shell_output "#{bin}/psc rm #{scandir/"c"} 2>/dev/null", 1
    assert_path_exists (scandir/"c")

    # cleanup
    shell_output("#{bin}/psc finish")
  end
end
