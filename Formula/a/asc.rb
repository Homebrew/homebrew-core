class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.44.2.tar.gz"
  sha256 "bf3178d66e3a5a8f1179506a09207768de88cbfe194e020445b6f50e2c12264d"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c88ef58d04b4802ca9462d7e3da611f261a0535c4e2cf2684795b998d2d077a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcec4803a4e5258e87b4591fee2662e244229a1ec1455b3bec26bf24c7da43cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a780cd91f805f1a7ca3b40521269153555b08462fe6f7ba49c7e46d23a5c22"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b196ffaf1ec7116099a3bdc1dd7af3a8340c25b00319993aef00be45a8f20dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a64a189315750803ceca1befd4339004007226931f4ddcd22a603a57128f29d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a27165ab25a5aacd18d44f0a3433e41b775d4106a48bc794c1e0f59a809e33e1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
