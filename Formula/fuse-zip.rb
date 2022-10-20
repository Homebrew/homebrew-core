class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.7.2.tar.gz"
  sha256 "3dd0be005677442f1fd9769a02dfc0b4fcdd39eb167e5697db2f14f4fee58915"
  license "GPL-3.0-or-later"
  head "https://bitbucket.org/agalanin/fuse-zip", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5e038b72ce4c58d28d4a873c9ea4ba304d9cf6618d772b3397a2d682911cf568"
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
