class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "bb27738bc1a783a4f7eacaa7daf4a8d0eb76ef128d7ac890868f568b122456ca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45d5b9d8be15415ca718e499d015eeff0f13e0fc34450ab0f986c4a5caecd444"
    sha256 cellar: :any,                 arm64_sequoia: "91a1df5ecde72ec58b62a36be465eb612370455d02eb5f83dcf09b47364f70ea"
    sha256 cellar: :any,                 arm64_sonoma:  "c7e3572288c5652c590c8b58d1a1bbbc26270923dfded1862176fba0d1b5ab4f"
    sha256 cellar: :any,                 sonoma:        "bcd2fbb2787063c8a6e740c169d0cde07a9df4b74be4387271f6d55e7462775a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf48a349e85996645f83544cf3cee5d69fd7fa87a7845edd3cd6fffe973c73bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a46bd85e9044ac26a9081aba2449a6afd01267a9ed5cb670700adb407b503f94"
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
    assert_match "Connected: yes", output
  end
end
