class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "dc1fef378297f3bc57f4fcd2a502f389bdcaf4266601a1a3eb790e74f98542a5"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a982f640b75ab34dc7f281c27a6f58ff9b04009de6db89d0699b3a3936d4175"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a982f640b75ab34dc7f281c27a6f58ff9b04009de6db89d0699b3a3936d4175"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a982f640b75ab34dc7f281c27a6f58ff9b04009de6db89d0699b3a3936d4175"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed9f5667d23889af26f942c8c2ac43c9b651b625dc851d3e59b4e7bbf281f245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22918d7a8cce5e7647d877760736408b5a53f86f5ea4e14427964dc883788902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41ea79b3ac8fcd55d7c514416d22d7731b8ebb177f0935615c4c680326697dd8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ov", "--completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
