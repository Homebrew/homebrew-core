class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https://sorairolake.github.io/qrtool/book/index.html"
  url "https://github.com/sorairolake/qrtool/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "05f5c0abf7d312ed72a827426543969ca723d42068cd77e36e480cd670931893"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https://github.com/sorairolake/qrtool.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4fedf675d255076246a1c5dde75ad9cfe4e1d8daa4d4607cecfd0ace4da8361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28358907827b5af05d498f56ac94ce24403b8c2b83330d742039071ae4bbb598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff046eff17108907732e4e2743971ecdfff87e0d46b57e86367b55029d39d147"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb86182d74d2060068c14920e5fb6095f85f389333c4730569b1639f95cdce6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e5a9e20405e13b574d660c79cf9120500e4c2d14b5e0f001a1330ec5904009d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b82073cad1b195c1e9f1d6c6d81514e9d5ab6c5ddc38221d2ef26c70107689c"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"qrtool", "completion", shells: [:bash, :zsh, :fish, :pwsh])

    system "asciidoctor", "-b", "manpage", "docs/man/man1/*.1.adoc"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    (testpath/"output.png").write shell_output("#{bin}/qrtool encode 'QR code'")
    assert_path_exists testpath/"output.png"
    assert_equal "QR code", shell_output("#{bin}/qrtool decode output.png")
  end
end
