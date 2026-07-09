class LeafMd < Formula
  desc "Terminal Markdown previewer with a GUI-like experience"
  homepage "https://leaf.rivolink.mg/"
  url "https://github.com/RivoLink/leaf/archive/refs/tags/1.26.0.tar.gz"
  sha256 "0c81600f49ed1cf306afa52be5e6c95bd7906e0a8554e00959287fd7a183b421"
  license "MIT"
  head "https://github.com/RivoLink/leaf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70cc550d506372e6e3ead0bd729eabc6cd33a456d32675375e44c710e382fe8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cafbd6cdfa236c18a04496376fea81e9bcb87b95db3401bd8e7fad52ed82bf0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f496f4ace206db9a6959c185856900f625e0768aefa27346f8b5aea630ee060"
    sha256 cellar: :any_skip_relocation, sonoma:        "14f14771e9097057fbddfacfaacac2f8568153540cd7807085b940aa45bb8949"
    sha256 cellar: :any,                 arm64_linux:   "28d8fd16f8d25a7a5a02fca655cab3198f72ff9d57a2f794b425c0186e5359d2"
    sha256 cellar: :any,                 x86_64_linux:  "26c3b15899dd41b04275728ade759af774fbae0fa27d1e296a876b9d38ba6374"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install `leaf` binaries"
  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write "# Hello\n\nThis is a **test**."
    output = shell_output("#{bin}/leaf --inline test.md")
    assert_match "Hello", output
  end
end
