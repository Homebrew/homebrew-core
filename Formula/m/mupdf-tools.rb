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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f0334b7ecf3b6d2392efd12e73cbf1c82ecc94b35c47ff9d8bac3853358d72c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31d3b7280c334ca3be1603489485360c68deb3f0b34152843c18d49023f9dded"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59d5cc9014c99d4397d2d74bc873703b200830947ee773677e4eb2313724f233"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ba41b174ab6fbac41be059bd17178d6efc5105eb01a0be06f5e37997112b04d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e2e729669abf61989477a945d8b4d348f421957d0453ae17ca95f19b04f2864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7881353e40e0aa01fbb5af89fc168b3baf89333605ca09c79f1e53f288765c31"
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
