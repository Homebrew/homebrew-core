class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.26.3-source.tar.gz"
  sha256 "ab467fc2d888cd8424cdce4bc6dd7ec61f34820582ddf3769a336e6909d9a48e"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4875c44a34fb87f20fbf8800b59eafff01d495e8f58d00de1aa993fa50f509a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f85ebf9ec82c2f1bdf6fa7b2eb085f140806c72601e7d4927ca2c5c26caf4d00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44a24066b2b369836faf7f20ece604501ec1b3c99933c66852098160dc8f4ed1"
    sha256 cellar: :any_skip_relocation, sonoma:        "72699024fd07f5a390c16f03bac230c050906b4aa7f49ab42d3396c5c764a9b2"
    sha256 cellar: :any_skip_relocation, ventura:       "5ada821641d98156ab250a2cc6f1dade1ec782920f6e90ae6a572051e9bf4d66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdb20e52cb06e7480d29eb269e3b100210133169dc3a899fc6f3e42c46dc36db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3784c04294d453e8b4e2908d700578826596ad6a3116b7c1c4f73e2d2badfbe"
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
