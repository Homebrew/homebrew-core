class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.7.1.tar.gz"
  sha256 "460024d9795eb578be09ec2284af243627721151aa001aae6ffb5589380b2ba1"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda4028d4876c70766d9ae577c60741c5604de5673b8acae0e26dc4f5d8df08e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "803ea6ced03a51fc184834642a4abed39d82525146c410dd0c9471f4a132f4b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "200c351ba8ad70ddd893f6735451af5ecef7cf7670504af15b471b625e26c705"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe41c5dbc3b3ef5656a566a95df8227296c1b9c0bd17857892a641e3d54c73ec"
    sha256 cellar: :any_skip_relocation, ventura:       "aaf95c5c8d0b6d2acf5fb02ae129fb8d8db0b32eaabc878b6a9423a14cc5f0fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85b2d4cdae8247b29aaf22ba0390f2febcf5a9ee2dd9abd60cf7ae5fb9a1c1dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87635e02c1cf4066926983af95ae4b67647749adaf2020687c3b258e3937fc9e"
  end

  deprecate! date: "2025-01-10", because: :does_not_build # and :repo_archived
  disable! date: "2026-01-10", because: :does_not_build

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
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
    (testpath/"test.md").write <<~MARKDOWN
      _lorem_ **ipsum** dolor **sit** _amet_
    MARKDOWN
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
