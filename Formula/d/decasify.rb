class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https://github.com/alerque/decasify"
  url "https://github.com/alerque/decasify/releases/download/v0.11.3/decasify-0.11.3.tar.zst"
  sha256 "2404c9f1c163b4290aeb93694d3ad49181c0a389c3aea7ed6abab22489d14e93"
  license "LGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ff19c29a173914d458494a071d57926dae0d7144f8fdc02d4896da4937a523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "310a18371e2755a252635f86b206b2316ae0a9d126c57a2e9bc01835c1a95575"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96c10a27579028fcadedf827d1b5f73225f807a3ddbb8d7b99f94282f847c452"
    sha256 cellar: :any_skip_relocation, sonoma:        "b78974c9dd3ccfb401c2ebb9c9a44ab44cf75e9cd81f27c7fc118822f4c70b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39912a574e08da91ded66573bb340a5a5cbacafcea47a0030d44abfe496df055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaebb4b35dc5f6bdfd169b106bcc2b73c2b71d15943100aafda52beb2e1dc09f"
  end

  head do
    url "https://github.com/alerque/decasify.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "jq" => :build, since: :sequoia

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "decasify v#{version}", shell_output("#{bin}/decasify --version")
    assert_match "Ben ve İvan", shell_output("#{bin}/decasify -l tr -c title 'ben VE ivan'")
  end
end
