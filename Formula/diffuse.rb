class Diffuse < Formula
  desc "Graphical tool for merging and comparing text files"
  homepage "https://github.com/MightyCreak/diffuse"
  url "https://github.com/MightyCreak/diffuse/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "cceff03beabc83fc76c49ecdad6743b7bd709063167af851fe2ebae7a10b1394"
  license "GPL-2.0-or-later"

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.9"

  def install
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    require "pty"

    system "#{bin}/diffuse", "--help"
    assert_match version.to_s, shell_output("#{bin}/diffuse --version")

    _, _, pid = PTY.spawn "#{bin}/diffuse"
    sleep 1
  ensure
    Process.kill("TERM", pid)
  end
end
