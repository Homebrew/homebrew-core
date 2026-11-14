class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.20.1.tar.gz"
  sha256 "1e6e3a533bdfd5854272cd9f54143ddbd879f4e7699a0b2e7ac469fcaa9799f2"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7069a7fcc48565ffbc5d0e3961d74c13774d0bf5f4adebdc2eee905ce042aa1a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c631221785196c346e3b3729b86826e3f31dd43d248ea181de2aa94c4edcd8d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa19d796dae405e7bf63d163d2950b488f61f57690c1fb37904701438af69e56"
    sha256 cellar: :any,                 arm64_linux:       "7e18dc61fe1549c03d0cd63ad360f8ca2859c6d6fa8696ae4ce5639fa301e5fd"
    sha256 cellar: :any,                 x86_64_linux:      "60c5f7276f970f22a015861d94e5bde2e1548dace8c6879f85401ba3c25f491a"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https://github.com/BIRSAx2/mdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin/"mdcat", shell_parameter_format: "--completions=")
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
