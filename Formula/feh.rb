class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.6.3.tar.bz2"
  sha256 "437420f37f11614e008d066e2a3bdefcfc78144c8212998b2bacdd5d21ea23b4"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "106d4f76b8f0a27daa2532760e9542983ba5e90fad958986b372d0fadf2acd59" => :big_sur
    sha256 "bc1eabe32933bdc2adcfc2745a7de1b0c6708a01f52be9b8995ec791c42458bb" => :arm64_big_sur
    sha256 "35e556aeb00c123e1eb6f08cf17c47a1d6a71f48a598be550372ff5bf8315bbc" => :catalina
    sha256 "ad6eb668502ea6b5836d1ce358fbeeff14531a2bd4e978709f8409b0707da312" => :mojave
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
