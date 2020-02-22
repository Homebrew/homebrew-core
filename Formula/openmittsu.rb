class Openmittsu < Formula
  desc "Cross-platform GPLv2 desktop client for the Threema Messenger App"
  homepage "https://github.com/blizzard4591/openMittsu"
  url "https://github.com/blizzard4591/openMittsu/archive/0.9.15.tar.gz"
  sha256 "7c70de775716f8c01c6f6f4c812fd938f2aea979f6fe4562bb6a4089fa3b9cae"
  head "https://github.com/blizzard4591/openMittsu.git", :using => :git, :shallow => false

  depends_on "blizzard4591/homebrew-qt5-sqlcipher/qt5-sqlcipher"
  depends_on "cmake"
  depends_on "libsodium"
  depends_on :macos => :mavericks
  depends_on "qrencode"
  depends_on "qt"
  depends_on "spdlog"

  def install
    args = %w[
      -DOPENMITTSU_DEBUG=OFF
      -DCMAKE_BUILD_TYPE=RELEASE
      -DOPENMITTSU_DISABLE_VERSION_UPDATE_CHECK=On
    ]

    mktemp do
      system "cmake", buildpath, *(std_cmake_args + args)
      system "make", "install"
    end
  end

  test do
    shell_output("#{bin}/openMittsuTests", 1)
  end
end
