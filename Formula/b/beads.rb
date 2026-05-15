class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "60b0ea0399fcb409af41d25b26521a04ed8f8fbcd6a080fff5bb1c84cd7ddbe5"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8e2852b34419f5bbb7ad5df001bb478e784390fa1123fc4b843deba3b43c394"
    sha256 cellar: :any,                 arm64_sequoia: "d3940cea827805a40b0863b8fa6ca8389c1bd8d67bdd1663ba393231fc91ae88"
    sha256 cellar: :any,                 arm64_sonoma:  "cb555fe56f011981232a8159b28b9b372ff91b26be0bd26255f2dc088e040480"
    sha256 cellar: :any,                 sonoma:        "e4ec19f94cd8418b8f6c51b660e098f80bbd3e5a029eb4f03060c982cc8f2754"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45f3e4cb31c9e50af6a4704b9c9f116e8f2d7fd6be472912fd98df061a786ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0f8342473e2b1ef5f81f9430f790c66bb5c18867fbccd5a7bedae50c66ebeec"
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
