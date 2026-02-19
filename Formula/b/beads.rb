class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "729833efe66a404221df1e8921d48c88ce98c888d0f03700bc321c096a2c1358"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d003f20d3a32aca184951a538a71881a27717191812234769c43a7f13b96fc7"
    sha256 cellar: :any,                 arm64_sequoia: "69ceac00f0020baeb06f6b97135beb6767e3dcd0012e5d5678ce71263e2256d5"
    sha256 cellar: :any,                 arm64_sonoma:  "7bee78e8e6930c550a12bf57b3791ff0cfe41541c73cc2a1d2907e4729ce34ce"
    sha256 cellar: :any,                 sonoma:        "c4a37ce145654d595faab3fd3904ba69984495d755cee2e6a5ed1729ab7786e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d57454874a866799331d512a7389eddc1adc6e5b3a45eda34d3c822df1cda56e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc5785b9264840c9ac8a2462422c5c0d2e52b0c3175828ec325022639ba6877e"
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
