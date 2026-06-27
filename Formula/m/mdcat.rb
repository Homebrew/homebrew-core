class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.9.1.tar.gz"
  sha256 "f0e9b0909a209ffb9f3685b3aa3bb70fb9e71de1770704c4f0daa1c0ed534fb0"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de82683a45de072121a2047397251509410a1e48e5f61a3acaffc26c6580898b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3ac23874aebc06201b8cb59e7201ca39841fd2c699b8ccbc9636de48b86578c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a3a1a1a8fdec8e7557523fc35e66b582d1a4b4ae8816e0acd4cb7dab8aca00e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ce8a127796114a94a4c05933ae74c0d7e2f91c9a7b44dc63719c87e08b7a74e"
    sha256 cellar: :any,                 arm64_linux:   "88ee444ea490fde7b2d838c72d18188d5250c1cdf9025ab919728411829fcddb"
    sha256 cellar: :any,                 x86_64_linux:  "a139329d9e0cad192497d1996141bb0b375f970c2daf2225f0a6d1e19d6fb11e"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https://github.com/BIRSAx2/mdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin/"mdcat", "--completions")
    system "asciidoctor", "-b", "manpage", "-a", "reproducible", "-o", "mdcat.1", "mdcat.1.adoc"
    man1.install Utils::Gzip.compress("mdcat.1")
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      _lorem_ **ipsum** dolor **sit** _amet_
    MARKDOWN
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
