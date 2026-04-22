class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "21f6170bd039ab0fefc7ee686f391a7b0c919690074d056bfb0636d3233b1914"
  license "MIT"
  compatibility_version 1
  head "https://github.com/steveyegge/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "adad56fd7f1c4a793b273867b481d482511a9ad5b45176fcc70f6570d2fd6156"
    sha256 cellar: :any,                 arm64_sequoia: "9d98ac98cfe7962a69de01660bff97b092dcf7f7887f728c38def9e3dc035eb9"
    sha256 cellar: :any,                 arm64_sonoma:  "14b40b54c48b270187f0c381354abfb8a9b3d5e096d93c153a9e3aa04d029273"
    sha256 cellar: :any,                 sonoma:        "fb96949d8bfd34120d855a53f8456c9648321a7f460c982764866ee4e92c3063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de5b1406b518ac2cf765e0d7cda2a8077fb52893415479ec2684fe55e0e8528c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b48478656caf592d1bb3104c1d345c87fc546bed7ca9b2698a382ddab0046166"
  end

  depends_on "go" => :build
  depends_on "dolt"
  depends_on "icu4c@78"

  def install
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Build=#{tap.user}
      -X main.Branch=#{build.head? ? "HEAD" : "v#{version}"}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system bin/"bd", "init", "--prefix", "homebrew-beads", "--non-interactive", "--stealth"
    system bin/"bd", "setup", "claude"
    assert_path_exists testpath/"CLAUDE.md"
    assert_path_exists testpath/".beads/config.yaml"

    output = shell_output("#{bin}/bd --db #{testpath}/.beads/dolt info")
    assert_match "Beads Database Information", output
    assert_match "Issue Count: 0", output
  end
end
