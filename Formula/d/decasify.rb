class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https://github.com/alerque/decasify"
  url "https://github.com/alerque/decasify/releases/download/v0.11.2/decasify-0.11.2.tar.zst"
  sha256 "f43794dd8e6f4e1a75132a9892d69f8b4f5272d96dc0909c04915be09eda2e1e"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5043f42fb3fdb1bd8cfd1646ba1129a67547bc8a08f040ca4fc5a982e3d6153"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54d7f8aaa91adee89553bb3c59e516cfc36d80de88ea7edc8b72767cbee492c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba4878b8607b322cabd2b5342c690cb0bee6fd2cfe5c06adfe101723f440b7a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6da897c0a968aabc626316efa5bd65e5ef55c4c808cd30cdef102d29f8088798"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c31f0cbe3a4ed976df5cbf30249b123ed8cd183c3fde311d8423a0d31f1087c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd4f4a746c2870aab142b470608369780b064ccadd4ccfd5c0e7d62cf0cb95d5"
  end

  head do
    url "https://github.com/alerque/decasify.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jq" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

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
