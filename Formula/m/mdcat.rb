class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.15.0.tar.gz"
  sha256 "a70e81e1dfbef05d2a46fa21a0d035ac6881766eaaa425016c27ff27e52357c7"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4d70bc88ff4fadcaad4a5300901f6104190c5444f4fea280a932cc4046b5576"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7cf044d81a3f951483cdef7d08d1690ff78226c39c8a09d85970f32833803c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f1f7e3e0a08a40fa5ec90eda0f000d6762083813a8638269362265ad22a6d8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b41b6e6f0fdf5d49a52a4dce0c407025dcc5206d2b44efedfd0d7f61655f241a"
    sha256 cellar: :any,                 arm64_linux:   "dd168301d67278404a3ab9f26c397345016307178d037295131cb796f5e7bc46"
    sha256 cellar: :any,                 x86_64_linux:  "704d1f58dabfecf105b894e4b06d9a0dcf40337490b3ee8cfc55da8052ad9a8d"
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
