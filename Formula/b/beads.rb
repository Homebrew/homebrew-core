class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/gastownhall/beads"
  url "https://github.com/gastownhall/beads/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "892b8b641d1f9eb3fa9f0cddf704f3f41aea0da872e546fe623ddec30b2ea9cf"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "177187f3b96cbb368afeb6c6183df127366542e31b18869b3c73cf1281c29a6e"
    sha256 cellar: :any, arm64_sequoia: "c5d25601126a203f1aad282f46b1e325b02db54bfd68989067b16d5e1449ee4f"
    sha256 cellar: :any, arm64_sonoma:  "6dc2c1d63a641b0781b5599185895f55ba36a83bf4a7d4af637d620365a33fbb"
    sha256 cellar: :any, sonoma:        "94ffc4b49596090b1d917693d4c83ce32673954321aa7d36ad8a7a5ef679e757"
    sha256 cellar: :any, arm64_linux:   "24bc1bb65a8441983afc2a78427c32e02a2b23efe07241501934162308f9f7ac"
    sha256 cellar: :any, x86_64_linux:  "69775853ae28bafa20f1b280753424146360231c4a28ff1b324036a69028777d"
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
