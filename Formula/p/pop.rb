class Pop < Formula
  desc "Send emails from your terminal"
  homepage "https://github.com/charmbracelet/pop"
  url "https://github.com/charmbracelet/pop/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b7f68883e55004fd538faa78227afd474e4222e567c5cdd9d6c15f52c2befe45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc8ec1da3efb44e70714d7bad03473f0292b5ce736f8b9c0b9343afd3b5cfe44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d83a780dd2ddcaf2ff3888f6a2ad5236c87dc7850bf9b7a0acb0337465ae203"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e3f092967e61d33f452c3501b9c35c04e2272c1eb6105c69b1271f5ff19400a"
    sha256 cellar: :any_skip_relocation, sonoma:        "52083121e6d4264bde585e0844039e9a8c6d0bea4c8f9c92a21d6b5d2f7ad350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "767ef62db135a2419bd3d719bc5e5b668a87e7ccdc18de7a35e66beabbf42ad2"
    sha256 cellar: :any,                 x86_64_linux:  "cd7b586c2ac4ca0835197aac98bf14b604a58ef1b4c7ef29811101f2ea87efb4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pop", shell_parameter_format: :cobra)
    (man1/"pop.1").write Utils.safe_popen_read(bin/"pop", "man")
  end

  test do
    assert_match " Charm Pop  Hello!",
      shell_output("#{bin}/pop --body 'hi' --subject 'Hello' 2>&1", 1).chomp

    assert_match version.to_s, shell_output("#{bin}/pop --version")
  end
end
