class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.10-source.tar.gz"
  sha256 "c3a2eaf19b3f0d58f923bf7132b72eff6205db4cea2f9c4651ee5ec9095242da"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffaf15770ee84ae40e8bcbe12b9d702f9de834ff8dc304a9e1d429439ea52b1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e592df3c35700393e6b0743fbb5db3c71fc82a054317f76f22b12e83c53cce2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa06c3ed6f38144bde3f362eb9c6fee27a2b102e01bdb7d84af88043619db141"
    sha256 cellar: :any_skip_relocation, sonoma:         "303d8379c845810f780e7b36de7c98cfffb3be63394d2ae3c23d36e247fd35de"
    sha256 cellar: :any_skip_relocation, ventura:        "7c4bae1da7baf36b4caeeae64124931b1591c90a29c525c753c58c6b99ed92ce"
    sha256 cellar: :any_skip_relocation, monterey:       "25229798f035a95ea5e1540541d1b61041a80c95317fcb68cd972cf92ed98471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5141764d26a29c1247d8dd07c4591db072ecd1c32d64ab59ac3f510c2c809065"
  end

  conflicts_with "mupdf",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
