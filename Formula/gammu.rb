class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.38.4.tar.xz"
  sha256 "a8ba1dc52ee82562abd57e9546c409f2f887f45187aae012fe43af0b730611ae"
  head "https://github.com/gammu/gammu.git"

  bottle do
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
