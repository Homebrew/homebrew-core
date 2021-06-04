class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.9+release.autotools.tar.gz"
  version "0.5.9"
  sha256 "8d808ac6095aa8f19c11518c616d3b9039016acd7b49b309db28d56b2bba0641"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "87ca4bbe0945759d95b7ad1975c7b1a541a85a9ff4a2c3ff3d799ec7d9830b7f"
    sha256 cellar: :any, big_sur:       "e3c73cd81d98afc871c030341e3d0fcc4563280ac0838831e87bf9c6c3a70b7a"
    sha256 cellar: :any, catalina:      "ebd6a6b2fdc369a436debd55ee63fe234e03e52b41f0e5eb334506628b7c2149"
    sha256 cellar: :any, mojave:        "c60969a4721431a18a6bf07cf4df55e9fefdb62b11b64a62408efd4f09b1b309"
  end

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" # for C++17
    depends_on "pulseaudio"
  end

  fails_with gcc: "5"

  resource "mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-vorbisfile"

    system "make"
    system "make", "install"
  end

  test do
    resource("mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
