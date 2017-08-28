class Pillow < Formula
  desc "Python Imaging Library fork"
  homepage "https://github.com/python-imaging/Pillow"
  url "https://github.com/python-pillow/Pillow/archive/4.2.1.tar.gz"
  sha256 "de9ef5d5bda3bfb5d70abd07c2a98bbdfd4b8908fce3e2e7478486ed7ee011eb"
  revision 1

  option "without-python", "Build without python2 support"

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "webp"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :recommended

  resource "nose" do
    url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  def install
    inreplace "setup.py" do |s|
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
      s.gsub! "LCMS_ROOT = None", "LCMS_ROOT = ('#{Formula["little-cms2"].opt_prefix}/lib', '#{Formula["little-cms2"].opt_prefix}/include')"
      s.gsub! "TIFF_ROOT = None", "TIFF_ROOT = ('#{Formula["libtiff"].opt_prefix}/lib', '#{Formula["libtiff"].opt_prefix}/include')"
      s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdk}/usr/lib', '#{sdk}/usr/include')"
    end

    # Avoid triggering distutils code that doesn't recognize recent Xcode
    ENV.delete "SDKROOT"

    Language::Python.each_python(build) do |python, version|
      dest_path = lib/"python#{version}/site-packages"
      dest_path.mkpath
      nose_path = libexec/"nose/lib/python#{version}/site-packages"

      resource("nose").stage do
        system python, *Language::Python.setup_install_args(libexec/"nose")
        (dest_path/"homebrew-pillow-nose.pth").write "#{nose_path}\n"
      end
      ENV.append_path "PYTHONPATH", nose_path

      system python, "setup.py", "build_ext"
      system python, *Language::Python.setup_install_args(prefix)
    end

    prefix.install "Tests"
  end

  test do
    cp_r prefix/"Tests", testpath
    rm Dir["Tests/test_file_{fpx,mic}.py"] # require olefile
    Language::Python.each_python(build) do |python, _version|
      system "#{python} -m nose Tests/test_*"
    end
  end
end
