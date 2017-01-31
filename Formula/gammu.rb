class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.38.1.tar.xz"
  sha256 "034c688bed41fcd9ce203871194f8cea84ebf70881fd88f0e003af2543c18c5e"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "5ea25b221da357885e6ffc6be7957b86fcecf658c9fe66b51374b434cd176b47" => :sierra
    sha256 "742438943d38bf551fa08c1db1ec3f0bd98da03d10ddd425c0de9bf79dc02158" => :el_capitan
    sha256 "e0d56e06dd76d729553588bce70f7bdb42c40e5ee9694a86ed3d742c9bf27a4b" => :yosemite
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
