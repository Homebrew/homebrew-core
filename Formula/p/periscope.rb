class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v1.0.1",
      revision: "a279bfd38e6ff8f4730e52fc670d8e24b98eda7a"
  license "GPL-3.0-only"
  head "https://github.com/anishathalye/periscope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5765ada2bc369b8ec6146bd7ce9e93d1e30d8bb97069d940dc17ef4fb1b2ffa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6d94c3ed7b19367c483d2e757040f66eeb55c7109d5b852ef95a4b2dceac4a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "151bac7b4998a735eb059417d814e796f26edb35a795d89542fb5f4ac35d5cd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "461ffa9b2eda689da1a8f6d35cfb1d348a44a438a9051551d594c02781235d60"
    sha256 cellar: :any_skip_relocation, sonoma:        "e793cccc4729c4b1a7dc3621ec0f16f266bf3c148e3a4e0035b4bae2de7a0c5c"
    sha256 cellar: :any_skip_relocation, ventura:       "62beda5a28e320d04f9bb95613918fd7b55a6d59687b3db1ecb9844b4bb51889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a853559bf9a3baac07b99b216416b69ecc445e3045b7147a2fae07c335d9db18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee3133ef30216e3c0d0c07d53af60848f4fd1d1815746dae655eafa8c39d4bce"
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
