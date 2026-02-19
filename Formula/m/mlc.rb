class Mlc < Formula
  desc "Check for broken links in markup files"
  homepage "https://github.com/becheran/mlc"
  url "https://github.com/becheran/mlc/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "635c05b2dacc3769089f3a8854bebac2b06605280648d07d0136996b1d1de596"
  license "MIT"
  head "https://github.com/becheran/mlc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53f3cbfaf325342b02159254ef76d9662dd1e43ca0306c077d48383e426bbd49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bcbbb02edc73eb77b65b210492ee793565303c99f3705a2df88e5b48585289e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35d38d67b828a4acebdc9cedc31425c865bf87d314aa7c03a1a7182d27cd8652"
    sha256 cellar: :any_skip_relocation, sonoma:        "735ecd15c43aaef25d4bbf33937057d868011c586652e4525b5ec2d2425fe277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec8e9ee4cb303a6f3bb5cd58000e817f6147e40b892920b0e326e2cf11e2f5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28cd68a8dc923a784360d646cf81244900f0ec03bfd4885063fe395765cc3620"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Explicitly set linker to avoid Cargo defaulting to
    # incorrect or outdated linker (e.g. x86_64-apple-darwin14-clang)
    ENV.append_to_rustflags "-C linker=#{ENV.cc}"

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mlc --version")

    (testpath/"test.md").write <<~MARKDOWN
      This link is valid: [test2](test2.md)
    MARKDOWN

    (testpath/"test2.md").write <<~MARKDOWN
      This link is not valid: [test3](test3.md)
    MARKDOWN

    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+0/, shell_output("#{bin}/mlc #{testpath}/test.md"))
    assert_match(/OK\s+1\nSkipped\s+0\nWarnings\s+0\nErrors\s+1/, shell_output("#{bin}/mlc .", 1))
  end
end
