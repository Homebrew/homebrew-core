class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.26.8-source.tar.gz"
  sha256 "e8d248a666d2386f4a2014d680b6e88de5ce9fd8c847b0e274cbecc124f33cc7"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16ed11ea6860338650fd105f797c439ce6b4624b8b19a63c19da39428d67475f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9da210bcfc3e570126636d77ff6a2afe5cb7c4cd5694add7a48f7cf710246731"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9346b9647b8069c150a7af0d801d93a7f807991ed7b26f96388619a86e91a4d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "375261021a361aa5b14ad8063371d98b9d11365e6c2b5bbbd5cd3cd89f127ba4"
    sha256 cellar: :any_skip_relocation, ventura:       "dcd8863de07d48059c867ed4190ac3e52c8bb9efa70f7fc85a61a10b5ceabddb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "349ed61d36ce154a03114d4a9c6f7be09e84ddd87cb38d47c4f383da7a30d455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d3812e3cfe73a754f94d0ad63a86960d3b16033a1351579865bef70d1630972"
  end

  conflicts_with "mupdf", because: "mupdf and mupdf-tools install the same binaries"

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
