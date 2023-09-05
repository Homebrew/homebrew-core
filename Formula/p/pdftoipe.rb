class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 14

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb72c10c47b346809f3b7892640db72b3a1ad6b7018246d280347b97d329768e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62d95fcd05a50ea982082c728b79d238ec698f5f80d3676dc50962252e999a74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c20579989f0c30efb7fab038c4db2a001c5b775c14c77b59548b252e7f656404"
    sha256 cellar: :any_skip_relocation, ventura:        "cf06a50e44f78af087315543f11453c8d49c3292703bdcb9f2607aefea401838"
    sha256 cellar: :any_skip_relocation, monterey:       "89ce6777c2393c99377aa38d7547da1f133ba0691627f4a7ed12a17a7c2153c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "77574786c5bef2a6cc9fcbe412eac66fcf07fc2af49acb46b47b71d895f1c2a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47491bdd49e4bb4e73e10c96d06aa3ac00f28895497669af948dbaf0c6dcef33"
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  fails_with gcc: "5"

  # https://github.com/otfried/ipe-tools/pull/48
  patch do
    url "https://github.com/otfried/ipe-tools/commit/14335180432152ad094300d0afd00d8e390469b2.patch?full_index=1"
    sha256 "544d891bfab2c297f659895761cb296d6ed2b4aa76a888e9ca2c215d497a48e5"
  end

  # https://github.com/otfried/ipe-tools/pull/55
  patch do
    url "https://github.com/otfried/ipe-tools/commit/65586fcd9cc39e482ae5a9abdb6f4932d9bb88c4.patch?full_index=1"
    sha256 "61f507fcaa843c00e5aa06bc1c8ab1cbc2798214c5f794d2c9bd376f78b49a11"
  end

  def install
    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
