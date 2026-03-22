class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "958907d246633ae82b47885005afa652827f8d9339cd5f02f5bbbaf650012b0b"
  license "MIT"
  compatibility_version 1
  head "https://github.com/steveyegge/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df5784ff5fb870064e28d97a7df6340b0e51b81d7fa6e193a195b664e2f47190"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df5784ff5fb870064e28d97a7df6340b0e51b81d7fa6e193a195b664e2f47190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df5784ff5fb870064e28d97a7df6340b0e51b81d7fa6e193a195b664e2f47190"
    sha256 cellar: :any_skip_relocation, sonoma:        "38201bc077d1bd072c2449182a7c145ed613792abfd8fa3c9b6d1595a8f94f9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42c4b629fea892eca335400a5adf3d88786033cc0a960b4494a6a9b7c45fdb28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b29e43ebe79612ffa32a98d653f887ff321b64941663566fb66faf8a40040e"
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
