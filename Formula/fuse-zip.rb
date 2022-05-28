class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.7.2.tar.gz"
  sha256 "3dd0be005677442f1fd9769a02dfc0b4fcdd39eb167e5697db2f14f4fee58915"
  license "GPL-3.0-or-later"
  head "https://bitbucket.org/agalanin/fuse-zip", using: :hg

  bottle do
    rebuild 1
    sha256 cellar: :any, catalina:    "70905b7f3ba6baa6683d7ad1cc0ae51ae9ad37a2c4c037de96abfec298fbd7d0"
    sha256 cellar: :any, mojave:      "f99be52df0a2ff2842c615bb4fa255c4400b382d2bb98d14e023223956edb245"
    sha256 cellar: :any, high_sierra: "e72d442a43e1396c8a744e73bc9d197cbef7bb996bba97bff4b377c253c12ed8"
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
