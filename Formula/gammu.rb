class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.37.4.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gammu/gammu_1.37.4.orig.tar.xz"
  sha256 "ee345d9e1a06fd055bca8a4b418778a9568178a2c34082e820f86851c535f869"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "aed46b5bdf73cda9f19458cada16fa818d31534dcb2a29761487ad314ff0b6db" => :sierra
    sha256 "b120f66edf3aa96dd6b934e164753b26dbaaf54bab93cd4996c5604fbbf661e5" => :el_capitan
    sha256 "998c00a999450a91711b99534015b6f4ff4f8e48f479420370782b576982e52f" => :yosemite
    sha256 "7818e0e49b9a6546a68a12df16fd165e902d5ddf12b41f3a8ee75580da484198" => :mavericks
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
