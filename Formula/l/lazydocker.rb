class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.23.0",
      revision: "cce9d40f43c08c42a401135467aec4500895b21a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea354ddd33e98027999fb1eedcf4e72756a471adb004f036f7fc687d176abc68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70c429e2b09656ade4f92a67d4cf8493f936f901b3b2ce1e895640db3cae5eeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d665c6df48bb7d0fbfc88b0ac658bcf2e558fa6d08da5ef3c21320c7b1b82ecb"
    sha256 cellar: :any_skip_relocation, sonoma:         "85e22cc9cf5375ca9783c3d4db24cd31caad8674e5d656e670aa8f537c09bffc"
    sha256 cellar: :any_skip_relocation, ventura:        "ca7cef3abdf7dfe64654b74fa55512766d7a020ea847b7e218323488c64f6f26"
    sha256 cellar: :any_skip_relocation, monterey:       "4e58a7613f1f764e7553e47fdea38d562a5ec60ece5e1a0ede3440608ee4e114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f57864905d2ac4a8540ce0384366e59cb196dd8655a52a645f77d83a3073a692"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
