class Fdclone < Formula
  desc "Console-based file manager"
  homepage "https://hp.vector.co.jp/authors/VA012337/soft/fd/"
  url "http://www.unixusers.net/src/fdclone/FD-3.01j.tar.gz"
  sha256 "fe5bb67eb670dcdb1f7368698641c928523e2269b9bee3d13b3b77565d22a121"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(%r{href=.*?\./FD[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sonoma:   "78daa3983f98bea1071db92ef70b8c9a3ea5e01f1d36a32d093de1512b1a65d8"
    sha256 arm64_ventura:  "6307f6eece0a8e13794fb57ef3ac793c5f72bb2769310803e4fee5bb30352e2b"
    sha256 arm64_monterey: "770b2d767ccfa06c3fe7a4066b59a9e067b27a2f719bac604a1588c7ec57c134"
    sha256 arm64_big_sur:  "e4346ef1c465a9753d44998015f004ef76d49f35b57e224c4c74da48fa00a226"
    sha256 sonoma:         "4d5d5dd54d0dee95bbc98e35e9bdd76fb36155f3f01c5374b86249ffe1576e8d"
    sha256 ventura:        "77caac2a97e0b941e44f6985c618f7877d75d918cc73d90b1b7c2e87a9e647ba"
    sha256 monterey:       "6468c945d2556066eab41175891ea46918c319398a2f10767a0af4d4dc698c9f"
    sha256 big_sur:        "c1c2dcd4d0e97e717dd9444c9ac8b37d77810c8162a481106d68be3c54f999a9"
    sha256 catalina:       "6272d033132a7a2c355ab19629241021087c606de3114e2ebe4aa301e6bee840"
    sha256 arm64_linux:    "f711ab13e2d255a899f98e9b4d1938dd8fd94236362c62a8fcdbcd3b9346dc54"
    sha256 x86_64_linux:   "b7a4047ede40d7981d2496e42cf32f2886a9bb182a2275f4697b70f20ec5f7f3"
  end

  depends_on maximum_macos: [:sonoma, :build]
  depends_on "nkf" => :build

  uses_from_macos "ncurses"

  conflicts_with "fd", because: "both install `fd` binaries"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/fdclone/3.01b.patch"
    sha256 "c4159db3052d7e4abec57ca719ff37f5acff626654ab4c1b513d7879dcd1eb78"
  end

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "MANTOP=#{man}", "install"

    %w[README FAQ HISTORY LICENSES TECHKNOW ToAdmin].each do |file|
      system "nkf", "-w", "--overwrite", file
      prefix.install "#{file}.eng" => file
      prefix.install file => "#{file}.ja"
    end

    pkgshare.install "_fdrc" => "fd2rc.dist"
  end

  def caveats
    <<~EOS
      To install the initial config file:
          install -c -m 0644 #{opt_pkgshare}/fd2rc.dist ~/.fd2rc
      To set application messages to Japanese, edit your .fd2rc:
          MESSAGELANG="ja"
    EOS
  end

  test do
    assert_match "Hello Homebrew", shell_output("#{bin}/fdsh -c \"echo Hello Homebrew\"")
  end
end
