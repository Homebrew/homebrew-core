class Flac123 < Formula
  desc "Command-line program for playing FLAC audio files"
  homepage "https://github.com/flac123/flac123"
  url "https://github.com/flac123/flac123/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "c09676dce51383ce4fe7a553e67f4369918cf40ee6d922e585e50c11bce9e227"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7767128158cc744c62fda8c0c6e9c22dd2732e5e04e15b47b79d6bdef89c4a1"
    sha256 cellar: :any,                 arm64_sequoia: "f1d6d3f1269accb9be1c482d9cfa9179a29423fe0dcc9ab8823132e4de9d861f"
    sha256 cellar: :any,                 arm64_sonoma:  "5f3eec5bb05991c31ad6d90767ba8a83ca4892bd0a07b14db323d4886c4a2d0c"
    sha256 cellar: :any,                 arm64_ventura: "81c798f14de5a0de0d9337f9c01416060d2a3cd8252a8a804dfdd15f0783ff69"
    sha256 cellar: :any,                 sonoma:        "6a11b91f03fd6601ce00e41b8835d2635a428ce78bdf1dce23db3b4b79da9365"
    sha256 cellar: :any,                 ventura:       "ed0839c5d9d6ba86b97c1d1482f5a3371c32a41c88f62cd42fe7526ba6ea56f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "782a7b74ca5a89826daf8870300d177f0c982f519a7c8f577ec331c4604b3c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3afd087ed1f308b93681775fc2f35572d49156534cfba450cc3aaef4b0d10885"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "popt"

  def install
    ENV["ACLOCAL"] = "aclocal"
    ENV["AUTOMAKE"] = "automake"
    system "aclocal"
    system "automake", "--add-missing"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    driver = OS.mac? ? "macosx" : "oss"
    system bin/"flac123", "-d=#{driver}"
  end
end
