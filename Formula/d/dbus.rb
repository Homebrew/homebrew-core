class Dbus < Formula
  # releases: even (1.12.x) = stable, odd (1.13.x) = development
  desc "Message bus system, providing inter-application communication"
  homepage "https://wiki.freedesktop.org/www/Software/dbus"
  url "https://dbus.freedesktop.org/releases/dbus/dbus-1.16.0.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/d/dbus/dbus_1.16.0.orig.tar.xz"
  sha256 "9f8ca5eb51cbe09951aec8624b86c292990ae2428b41b856e2bed17ec65c8849"
  license any_of: ["AFL-2.1", "GPL-2.0-or-later"]
  head "https://gitlab.freedesktop.org/dbus/dbus.git", branch: "master"

  livecheck do
    url "https://dbus.freedesktop.org/releases/dbus/"
    regex(/href=.*?dbus[._-]v?(\d+\.\d*?[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "21f1e3d64a2f5bdabcf677feb6cd0859b80ae08ebc5cd6987a34f5ce1a158d9f"
    sha256 arm64_sonoma:   "f1435a361d873e109e1ca1d5ee6860afe9b1cfc2f8f34861ccbdd0072e1ee2c1"
    sha256 arm64_ventura:  "16cb153287e8648faca1c3295230ee396e1bb673d8f02377f89e05543739d5c9"
    sha256 arm64_monterey: "62820f7cd2eaa5f6740b545789d8e7c086bbf4bcbea8f9f4c80697093b44dfa3"
    sha256 arm64_big_sur:  "044d1eb259c6839dd79eec4f8d16a857527bf208000796ac2b601dd95742aa34"
    sha256 sonoma:         "49b5c4368f559f8babb1d20df4770eff544344fa54fec78eb79e48a449738f27"
    sha256 ventura:        "6ed57658615731eac10b392a02031bd9e42025764bb806070c7acfea86bd8e5d"
    sha256 monterey:       "16088446358af9272061f867619f705cbb53e1f50eae96698632a8ecbb0b4662"
    sha256 big_sur:        "a1b4ecabee0fb8f2a28348cfc267bd805d40be8e27dd37ea1a8f2c7e988409ce"
    sha256 x86_64_linux:   "9037402e48fc19b05f8b621e0e32efa3b4214513f0b4737894ef3d57704ce81d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build

  uses_from_macos "expat"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      -DDBUS_BUILD_TESTS=OFF
      -DDBUS_ENABLE_INTRUSIVE_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    # Generate D-Bus's UUID for this machine
    system bin/"dbus-uuidgen", "--ensure=#{var}/lib/dbus/machine-id"
  end

  service do
    name macos: "org.freedesktop.dbus-session"
  end

  test do
    system bin/"dbus-daemon", "--version"
  end
end
