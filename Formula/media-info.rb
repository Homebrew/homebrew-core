class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/22.03/MediaInfo_CLI_22.03_GNU_FromSource.tar.bz2"
  sha256 "79c00eac81d213fb59ba4f73afdb310669795a41c47e3fbd5114d2c7d9f7f33d"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b7c9d8a2ddf925e9e9406aa0e81c07c60d84dd719ad563802166173d4f5071eb"
    sha256 cellar: :any,                 arm64_big_sur:  "96a36b6b6707367fba727e961f8e2d7310995bfff65ace9e3f79474ebb61cbe3"
    sha256 cellar: :any,                 monterey:       "e8ec18336c7d4a64e5f6c418aeaeb6b83eb7ed874d7767abe30d8ba46eb28387"
    sha256 cellar: :any,                 big_sur:        "366cd30756a0340ada5a54cda9c8bdae069a84ae37ec42927d28b30d13e62c36"
    sha256 cellar: :any,                 catalina:       "e45e7e78c840065b379fa414a46005f9f3a886c41556d982ff21f1fb8310ed27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "028dfa7da2d594df6219f7c9beb371e687bfe8675c2b24fce948281901bbddd2"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end
