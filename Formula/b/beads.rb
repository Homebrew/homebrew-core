class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "b3a1564608eb23626c097bb7efa751543b3ed50d49379a38dabd14727e6550e6"
  license "MIT"
  compatibility_version 1
  head "https://github.com/steveyegge/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0c273c048284e0c98b4ff1eef26fa54343a2cc5d93c5b44510f4e5a43975935"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0c273c048284e0c98b4ff1eef26fa54343a2cc5d93c5b44510f4e5a43975935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0c273c048284e0c98b4ff1eef26fa54343a2cc5d93c5b44510f4e5a43975935"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbc2ee878a257d2caae9ae61e8dc8c32b7d2f75edbe03f12c05ab6f5b666bb2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96c1456f4216012e3ab1939c7c8e19c9cca6e5a8386b5366dd052536904805a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ac9a9c207064c419ce44d091f48ff0860c9371ab7b2cb7313b823fa8dd8edb5"
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

    system "git", "init"

    shell_output("#{bin}/bd init -p homebrew-beads < /dev/null")
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Beads Database Information", output
    assert_match "Mode: direct", output
  end
end
