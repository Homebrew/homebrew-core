class Lndir < Formula
  desc "Create a shadow directory of symbolic links to another directory tree"
  homepage "https://gitlab.freedesktop.org/xorg/util/lndir"
  url "https://www.x.org/releases/individual/util/lndir-1.0.3.tar.bz2"
  sha256 "49f4fab0de8d418db4ce80dad34e9b879a4199f3e554253a8e1ab68f7c7cb65d"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7006aa215d5d08ec49a73e38106b576ba310ca7f7c18c5c0c8a436d2653a5a90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16bf85f690f6bebcbd9f3e6fe4b73cd5b184484d3ba2b641a5300cd7d5f95c91"
    sha256 cellar: :any_skip_relocation, monterey:       "5714cd4c9e37de6528d8f25996824855df115b4a002a5927049ad792ac2add41"
    sha256 cellar: :any_skip_relocation, big_sur:        "0acb2e9c42ed5d6c9ee5137fe3b520f8a97b736ddefff61aa6fee49ca1bbce12"
    sha256 cellar: :any_skip_relocation, catalina:       "f8f2e26ed44cea1bac963ba171402e74832ce57664d894ea759870391ee177f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c50f8e7abd5f1224bb796c008417277a32764c86f8bd7efb81f0c43886aa301d"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto"  => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    mkdir "test"
    system bin/"lndir", bin, "test"
    assert_predicate testpath/"test/lndir", :exist?
  end
end
