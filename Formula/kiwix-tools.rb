# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class KiwixTools < Formula
  desc "Command-line Kiwix tools: kiwix-serve, kiwix-manage,"
  homepage "https://download.kiwix.org/release/kiwix-tools/"
  url "https://github.com/kiwix/kiwix-tools/archive/3.1.2.tar.gz"
  sha256 "86325ec31976d40357f08c520806cf223fa1b0a5edb02ad106c2a0d6746ca364"
  license "GPL-3.0+"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "kiwix-lib"
  depends_on "libmicrohttpd"

  uses_from_macos "zlib"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/kiwix-serve", "--version"
  end
end
