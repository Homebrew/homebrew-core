class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.28.7-source.tar.gz"
  sha256 "4052527c5064dc15033f8c2d842665afd409be520c9f52945ef703e5dec9d3ea"
  license "AGPL-3.0-or-later"
  head "https://github.com/ArtifexSoftware/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    manifest_sha256 "ccacdf77caff6118c124c2f379ccdb4d6aa4cc271c54aa091988ca10139a2129"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96da09b3643b53233668daa4ade4a154646b3d418d6427271ad2a320ebc957cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a58675e3f283561368170a32214ccf6b26964406c54444800f87a33370e8d7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4283c8747b7caa0d2329be912adad2b25777b468caa1d966ceab14dc86f8c5fb"
    sha256 cellar: :any,                 arm64_linux:       "45e1ab12afcf438cd8503bcbf4bdc9cd2950db7b8356a50286a7110f1a7bc6c4"
    sha256 cellar: :any,                 x86_64_linux:      "9a7efcb3d6f3bdb529fc25593972f67dadf623a6f0515c48158d7d6953ca5e8d"
  end

  conflicts_with "mupdf", because: "mupdf and mupdf-tools install the same binaries"

  deny_network_access!

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
