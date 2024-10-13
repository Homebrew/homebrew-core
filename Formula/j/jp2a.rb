class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://github.com/Talinx/jp2a"
  url "https://github.com/Talinx/jp2a/releases/download/v1.3.0/jp2a-1.3.0.tar.bz2"
  sha256 "0ed7cab807488744e90190312aeb6470aad5a37e7eccb4998ddbfd351401ebe7"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a2bfd3d074bb5a4e30e7dfc93c6567c472fab977f4ef442e9674ed7f5c155ac"
    sha256 cellar: :any,                 arm64_sonoma:  "8b4d914c4716f418ef83dd710d12b24088aff7879a222d1cd21f3f53f46b8dd3"
    sha256 cellar: :any,                 arm64_ventura: "435210b7b226f8d85068c756e248b15da0902dfeb8d98737657f3cac5816b366"
    sha256 cellar: :any,                 sonoma:        "bede412b6668ef9b28ccaaa447306203ab45fc8113d6a818dc3dec63eacca74d"
    sha256 cellar: :any,                 ventura:       "a3a61764d9f0767d0feba642d6184f52240ae05d901671788a64a343d66cd83a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2ff303b3284ba747f74ff49c598a4b0430086cbe3c1a735d841c85f8436bd8e"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "webp"
  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
