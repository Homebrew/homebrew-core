class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https://github.com/alerque/decasify"
  url "https://github.com/alerque/decasify/releases/download/v0.10.1/decasify-0.10.1.tar.zst"
  sha256 "5cf9781df864c211d191f73ae014da7de1e02cad6507850728fea5a0b9f946e7"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35c382d68af07363f18cc1384c4f532d7844423e80da9463e99e1e5f6f0ac799"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae81a1439bc5fd75fe76d00beac0d7ca2f3a353406cda1ea185d04a4669c3e62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d08eb9e9cf5109f3f98550bfd95e9034c708f892164f564aef14caef1b050dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ba5797890e07052e2551b57eb6bbb658f8b5dc153acc3fee17c08a0dca66a6c"
    sha256 cellar: :any_skip_relocation, ventura:       "b5c26c8f65ce573687bcfc1dde10b6533f7e459ac015da51aefdf881449a98e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc2aa4d7df5cb0248eaf037e5b9a1865439d15cab73d3ca02a26cb3efacca67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd970ae1d4b0e1b67a015c65d80e633657761fbc357a0c9e60075ca991c83658"
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
