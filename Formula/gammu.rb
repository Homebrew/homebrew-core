class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.37.91.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gammu/gammu_1.37.91.orig.tar.xz"
  sha256 "fb353ed465b1ae408485e55c97f3a9e910af2c271b03a5bf3aab61bb4225fe00"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "41c260a2ef6b98e3e578e0355c3652cb7792a6299b544c65dd123d4a919111ec" => :sierra
    sha256 "42b990ef2dccf77e19faa405eb5ecd4e9d09ea1162c1a55ee5dc3cf69e2fb561" => :el_capitan
    sha256 "57356e355fe6a9f5751b7c54ac7a2e2492f326fb8a9a9afdb6ffda8ab80f9264" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "glib" => :recommended
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
