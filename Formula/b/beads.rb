class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "21b8de770b6e38bd8db5621a4242812e06d7f630c6b49e1fa477812931954bd7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fbd23348ef33aed3fb221f2379400070f52d4591a5329b8a6b6440ad94137560"
    sha256 cellar: :any,                 arm64_sequoia: "42135b0e332381c32e41998676653d48dc4933719b9122a7e831ea2d31e6b63c"
    sha256 cellar: :any,                 arm64_sonoma:  "9082b1e9382d0b922dd57ccdc50fa6e9bbf1a03f93cb7a5bfec1fc205c1d01d2"
    sha256 cellar: :any,                 sonoma:        "9e60df7418f8ffe43c0fce862146907c7eaa55a28b10b02ed52c11829aba2f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aac500ad860d33d130cc8957bb70e09cd43a4716b5300b23009a797c5fa3d1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31df70d3253a770a9d77577cc1c12901ad7c990ea80ce3360e5fb1d10500707c"
  end

  depends_on "go" => :build
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
      -X main.Commit=#{tap.user}
      -X main.Branch=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    shell_output("#{bin}/bd init < /dev/null")
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Beads Database Information", output
    assert_match "Mode: direct", output
  end
end
