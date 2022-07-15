# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Pdftotextmovie < Formula
  desc "A bash script that converts pdf papers into text movies."
  homepage ""
  url "https://github.com/shyamalschandra/pdftotextmovie/archive/refs/tags/v0.1.1-alpha.tar.gz"
  sha256 "60c603f4c54e0112de2f677fc4bb2cbb2c42a55c23660cfaeba3b676e9cbbba2"
  license "Copyright 2022"

  depends_on "pkg-config" => :build
  depends_on "poppler" => :build
  depends_on "ffmpeg" => :build
  depends_on "imagemagick" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "pip3 install --user pdftotext"
    system "pip3 install --user numpy"
    system "python3 set_path_numpy.py"
    system "pip3 install --user TTS"
  end

  test do
    system "false"
  end
end