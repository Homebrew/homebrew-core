class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.27.0-source.tar.gz"
  sha256 "ae2442416de499182d37a526c6fa2bacc7a3bed5a888d113ca04844484dfe7c6"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a465b90738e3ee8ace075c446b1907174a9a0bfc3633ea75696a7e49cfa2447"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0feb29ff9bae4b5a1af0117c82d37c65dd73ef224b7a8b2493148d40f3c36482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f810ae8e2b9e20d8598cc1e57370de8efaab899f13826cb9108ef78b72cfb34c"
    sha256 cellar: :any_skip_relocation, sonoma:        "91d5219800c5f5f584071166ca0b630cb53c62d97664d4bf0cdb3013dcf04ccf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e04d79fd7ab56f455ba96cc666db781328ee11c4f6712d4ac928695e0c7943f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76732c0df84c7968f754bd784a698551690ffea25adb4a577ebd8b1fe547be21"
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
