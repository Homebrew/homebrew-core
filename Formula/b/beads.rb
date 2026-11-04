class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/gastownhall/beads"
  url "https://github.com/gastownhall/beads/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "ff97bd5320cb09613cccd77532eeaec29bdb0dc26af7bbbf2275913e97dbaada"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d4f8baf77c4ae5aa90344053d837b8534b98e47a0a04171b4da79f1ec48ddd3d"
    sha256 cellar: :any, arm64_tahoe:       "20762147aef6051b1fb02aa6ec95aea22ae194d00307e2c21a6ef9dda784338b"
    sha256 cellar: :any, arm64_sequoia:     "b4ecb9dc79ce9b6492032801a1161907a9e35d9dd0367b9e5526e938484c7985"
    sha256 cellar: :any, arm64_linux:       "60f4168c01fd223b889d36f2639c804b74bc71a99f982ca22b58a588d24f0c2b"
    sha256 cellar: :any, x86_64_linux:      "780dc76595b627453f04312501807a85e30c037c1e8d63aa95c5b1d968047da5"
  end

  depends_on "go" => :build
  depends_on "dolt"
  depends_on "icu4c@79"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
