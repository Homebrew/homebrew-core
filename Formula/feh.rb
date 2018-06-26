class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.26.4.tar.bz2"
  sha256 "074f8527a17fc5add70018a7f3887d78d5bdf545611636b88641f27e9e844795"

  bottle do
    sha256 "032ece9317e826add619ca79c213cdc8c736c3452493c9cce01232ddc496c091" => :high_sierra
    sha256 "7c15b09949d13f2f68e44484d6337265dd5d6e19fd5f0610cadc35ac0dfc2a5b" => :sierra
    sha256 "437b568cef2b39fc8a7e40d7c238ed0aac5addcea982cb6cb8ad634aadf77628" => :el_capitan
  end

  depends_on :x11
  depends_on "imlib2"
  depends_on "libexif" => :recommended

  def install
    args = ["verscmp=0"]
    args << "exif=1" if build.with? "libexif"
    system "make", "PREFIX=#{prefix}", *args
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
