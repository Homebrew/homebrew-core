class Pop < Formula
  desc "Send emails from your terminal"
  homepage "https://github.com/charmbracelet/pop"
  url "https://github.com/charmbracelet/pop/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "1ac694148e286bf9bd75387a98ee66b41c554e989fae41314f4b762210e14436"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d40656b18811c7b842f55f5af03316af80f37a4d3adfb57c56355b64f14f0baa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d40656b18811c7b842f55f5af03316af80f37a4d3adfb57c56355b64f14f0baa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d40656b18811c7b842f55f5af03316af80f37a4d3adfb57c56355b64f14f0baa"
    sha256 cellar: :any_skip_relocation, sonoma:        "593ca788f28b3401496656e1acb7aebb52ddca911569e43990fd1d6a69d5d10a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "478e821c128f3a9b133e63759cffc23299d2357e48492b490cc37181b59c4108"
    sha256 cellar: :any,                 x86_64_linux:  "29ea0d37afd5137f74da17a157c69e2feb50a2b1b377073ef67398a43328eead"
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
