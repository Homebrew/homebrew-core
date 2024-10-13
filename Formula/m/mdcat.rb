class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.5.0.tar.gz"
  sha256 "fc7855277a2f5e0c9ca74f9a9f72c8f527dde8ae16d2aa9bbe6a249040592aea"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e091e8f07d47fb1fa69efae631c459a9e3f793ba8efee226a01f5de4201f80e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed13411f7ccee13439c01c33afa8be8f98746dc204744bda9dc55d1fc8fdb404"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "597aa7f1d640efb41bf3c9fad7b1869a2c91237a29fc712dbbbad2e9de71b9dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b282b41eea98066429f5bd4b19418ed0281fabc258292801199f45ba4b2a835"
    sha256 cellar: :any_skip_relocation, ventura:       "7757a1701707005ddabb6c8ee4fbe76641396029a6a8677eec1b7dd37d1939c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24dfd12efa1d77060747414c2c03796a11e6aa47489ba6af81a5b80848757d40"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https://github.com/swsnr/mdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin/"mdcat", "--completions")
    system "asciidoctor", "-b", "manpage", "-a", "reproducible", "-o", "mdcat.1", "mdcat.1.adoc"
    man1.install Utils::Gzip.compress("mdcat.1")
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
