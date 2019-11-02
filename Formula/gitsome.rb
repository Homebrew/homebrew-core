class Gitsome < Formula
  include Language::Python::Virtualenv

  desc "Supercharged Git/GitHub command-line interface (CLI)"
  homepage "https://github.com/donnemartin/gitsome"
  url "https://github.com/donnemartin/gitsome/archive/0.8.0.tar.gz"
  sha256 "6b0c9196d43c730b2d66ce39a78c25983661c2629ecc07f8bd50e92e25f8a841"

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "python"

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/5b/bb/cdc8086db1f15d0664dd22a62c69613cdc00f1dd430b5b19df1bea83f2a3/Pillow-6.2.1.tar.gz"
    sha256 "bf4e972a88f8841d8fdc6db1a75e0f8d763e66e3754b03006cbc3854d89f1cb1"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", ".[all]"
    system libexec/"bin/pip", "uninstall", "-y", "gitsome"

    if MacOS.version >= :mojave
      sdk_path = MacOS::CLT.installed? ? "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" : MacOS.sdk_path
    end

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdk_path}/usr/lib', '#{sdk_path}/usr/include')"
        s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/gitsome", "--version"
  end
end
