class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "6cbc05b2166a3c349e10a5bf651a875a654e50c33f530687cf7c8717c6560835"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d7cf0371796eaa0d2f923ba419c3cd84ada937c523ce1791809d38aacaab475"
    sha256 cellar: :any,                 arm64_sequoia: "1350aa5c7b5ca9d86c1b06e61a7eddb2a992b7e6ca6aa3dbb472f2298e554d4b"
    sha256 cellar: :any,                 arm64_sonoma:  "90bfbcf0faa5d41917d2c1c168da33b73e29b32a9ad4e5bcd49a77d442fe9577"
    sha256 cellar: :any,                 sonoma:        "fa6f3f51a997fc0712f4476374781e4b00d570e5861977d43fcf60897105bae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8642d75a6e1ff2ddbf41baf58f4af6388ff1e3790c395135b65eec17862e17f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5820a995d4c3e50913663af01c225d9f400a42e9ee1268f815955503282ae9e4"
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
