class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "85a9c6185d63eb8a300852947203cf5cdb4926249e3ac7f800a12df0f61d797e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f409c9cca986ca1217c1dcac0ba928c6a42e137249d2e55d66809293f1dd3e06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e1d331a0f9513b065013abd4167fe935007a3c8cdae213b2da9d965182541a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86bdeff77506957fef1669ae6bc6968ec221ae40b63c7be3837c982a8f305018"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9475f43e392b8fd9813860c0eeb4738f26b99160a45384252dc4991c1c47d5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81b01d95bfaa79007aea3152dadf8ece8c74de6a451096b5e15bd61bef43cdb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "041a4563aa52196cd34f4f02f98cfea35d2b0bbd4a9235c981b896dd107ea8eb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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

    system bin/"bd", "init"
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Connected: yes", output
  end
end
