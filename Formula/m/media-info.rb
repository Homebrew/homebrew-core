class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/24.06/MediaInfo_CLI_24.06_GNU_FromSource.tar.bz2"
  sha256 "4001264380c5f4ed224b542de2b6f6c517aa64b9364b194e2ab2939f355fbbfc"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fcfba4e54a79ed67933ee1adffc2ec21edbfb341895d11a95497a75cff31db28"
    sha256 cellar: :any,                 arm64_sonoma:   "24ab01c2d04ff3dfef9140f7fb1c4c08a40f11f83a2d073cb6d0d2a9299e3947"
    sha256 cellar: :any,                 arm64_ventura:  "e6bb4bf566a600f98b90ffbd502baff4e4612b762225bfe54d0e747058caade4"
    sha256 cellar: :any,                 arm64_monterey: "0de46f4d1f87a446d0564bf44c4ecd1c04304053c0b2481c7f4ee84ab04648ba"
    sha256 cellar: :any,                 sonoma:         "c3a1f44a8369d15d65ba73097f43086eac1acdc487f4cb23324d0f96540ca136"
    sha256 cellar: :any,                 ventura:        "984d8dc333983a7fe824a0af5a6e70ddd094fa800e5af63e50fe03204fd81657"
    sha256 cellar: :any,                 monterey:       "e8eabd1e4388f0ab62f33accfac14840a66087449e738380efc26611cf9f05aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5113125409dbbbf87d710bfe56592ff9593cde08412e220757e4ee9de3fdcefb"
  end

  depends_on "pkg-config" => :build
  depends_on "libmediainfo"
  depends_on "libzen"

  uses_from_macos "zlib"

  def install
    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/mediainfo #{test_fixtures("test.mp3")}")
    assert_match <<~EOS, output
      General
      Complete name                            : #{test_fixtures("test.mp3")}
      Format                                   : MPEG Audio
    EOS

    assert_match version.to_s, shell_output("#{bin}/mediainfo --Version")
  end
end
