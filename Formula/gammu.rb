class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.39.0.tar.xz"
  sha256 "66d1d991d7a993fdf254d4c425f0fdd38c9cca15b1735936695a486067a6a9f8"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "89c6abf8223d40d556f4e68954fd87513e27173accbbb1e0474153b8556b3768" => :mojave
    sha256 "d18ac85aafe7b0808af71def3812d623223234d17ce2f8281a3c673079e6509a" => :high_sierra
    sha256 "eeb48b7fe0b0b97f96aa3580c92b76e0cd59ece002eb1bc076efa30c85327ce8" => :sierra
    sha256 "abe55374ac1e3898e321af01126d0da4ad436be24ea2bd14e44cf61a386f4692" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "glib"
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
