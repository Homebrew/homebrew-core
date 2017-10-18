class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.38.5.tar.xz"
  sha256 "0f8c8f3568189c14eb20d792b759c6f22b6a35f47b4fe4abd52000160c7de2ed"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "0657669eda3e7bb1febb124ce89a7362b60d43afd5d88a5aa4143ae05b02667b" => :high_sierra
    sha256 "a25dd0c1236d5b26a214b9caa16e9963045b29a2e59391ef7993c2636656466f" => :sierra
    sha256 "e254b9cf36865dcdb99b5dc8701d052259bc8024b49f462cb805f58186b93fc9" => :el_capitan
    sha256 "e37cb111f1fe16aa168ac07d6515d2a59f1b02928ba19a2e123cc5b65c7b4fef" => :yosemite
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
