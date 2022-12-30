class Diffuse < Formula
  desc "Graphical tool for merging and comparing text files"
  homepage "https://mightycreak.github.io/diffuse/"
  url "https://github.com/MightyCreak/diffuse/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "cceff03beabc83fc76c49ecdad6743b7bd709063167af851fe2ebae7a10b1394"
  license "GPL-2.0-or-later"

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.11"

  def install
    ENV["DESTDIR"] = "/"

    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    assert "Diffuse is a graphical tool for merging and comparing text files",
      shell_output("#{bin}/diffuse --help")
    assert_match "Diffuse #{version}", shell_output("#{bin}/diffuse --version")
  end
end
