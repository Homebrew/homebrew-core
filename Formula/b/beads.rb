class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "db089aa41a3aa1f68f57ad72b632e2796dd5a045406366a68e001450889f0370"
  license "MIT"
  compatibility_version 1
  head "https://github.com/steveyegge/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "75791a4f359e348d3c6d974d108591354fb81dff1b17450d7d4355453f92804e"
    sha256 cellar: :any,                 arm64_sequoia: "fc69d08b4563a922af590eca4821a3d108bb69433f389bf7e1a6b5030199ed06"
    sha256 cellar: :any,                 arm64_sonoma:  "cc158d34d4f543bd829696d104774671b2387f56f1e7d37b33771623e2a75782"
    sha256 cellar: :any,                 sonoma:        "e2435ca8a160e696f5cd0ef7a5bbf3d9547fa0f070dad84d2b8d70a3aeede7f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb7628fcef7779c73743bd8ff20af88713d4f933adea2652d68433fccee936c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "467163e52e379e7d5536b58e0f9b05817d1dc2a8c391897e3f66648441b843c5"
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
    assert_path_exists testpath/".beads/config.yaml"

    output = shell_output("#{bin}/bd --db #{testpath}/.beads/dolt info")
    assert_match "Beads Database Information", output
    assert_match "Issue Count: 0", output
  end
end
