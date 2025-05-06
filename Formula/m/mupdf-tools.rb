class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.25.6-source.tar.gz"
  sha256 "5a51d8bd5ed690d3c8bf82b3c7c3f1cf5f9dde40887a36e3b5aa78a7e3ccd1bb"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf484f6cd99e32605f2c68d45eaf91a199b43cb7b2f0ac2b2d8e279a6e15fc8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5d9c98707c6feb9ca68449ab70c991d77de071f22cd8ea0ce52649c3ba516bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5585b9fcdf43af13ec7475aa5efc995a31e6eee9cd74afc4b9638300ce7c69d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "487118d917f2b5ac715efd3ff3a9606608df9c3555248ee4a2022852884f51bb"
    sha256 cellar: :any_skip_relocation, ventura:       "8879b23501753bc6b429b865b52166c1e0c5b5608978549573a5e3093788aa96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d21028813fc423cc4b1ca4777a8c322aba37d1bec2955368e77ffc1e9d853be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac555552f0f55c63a6e7e87bf90d2cebaeff0379af39480ef13ef3e15828d865"
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
