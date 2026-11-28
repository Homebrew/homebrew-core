class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.28.7-source.tar.gz"
  sha256 "4052527c5064dc15033f8c2d842665afd409be520c9f52945ef703e5dec9d3ea"
  license "AGPL-3.0-or-later"
  compatibility_version 10
  head "https://github.com/ArtifexSoftware/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/releases"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    manifest_sha256 "a96537f85740200d4477597d8824c2c6c51678c8b0000d0dff15b42684de27b8"
    sha256 cellar: :any, arm64_golden_gate: "9f468890b31b6d70ec1731d8101cb8bd70ef55d4e85dd586a8a9f4fbe5e42633"
    sha256 cellar: :any, arm64_tahoe:       "c20b39c28ced27d53b3452884faabacba4f85353d084a284e77aebc61d73ac1e"
    sha256 cellar: :any, arm64_sequoia:     "aafde4689f6b40e1ac44bb3386e71f020f124df5e12acde49db33041cbb49a54"
    sha256 cellar: :any, arm64_linux:       "bf9ee4e349ed07d425ef5d707f28d691b96f0a15078abeddcb7fd919a2451f62"
    sha256 cellar: :any, x86_64_linux:      "36cba2dc8f8cca7d1ead4d98aa0ba2474e763cc84d5c2544323c686ac954ecc6"
  end

  depends_on "llvm@21" => :build # Clang 22+ issue: https://bugs.ghostscript.com/show_bug.cgi?id=709448
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "brotli"
  depends_on "freetype"
  depends_on "gumbo-parser"
  depends_on "harfbuzz"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "leptonica"
  depends_on "openjpeg"
  depends_on "openssl@4"
  depends_on "python@3.15"
  depends_on "tesseract"

  on_macos do
    depends_on "libarchive"
  end

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "mupdf-tools", because: "both install the same binaries"

  # Build scripts import `pipcl`, which upstream unbundled in 1.28.1
  # Ref: https://github.com/ArtifexSoftware/mupdf/commit/ecef7b70bc5
  pypi_packages package_name:   "",
                extra_packages: "pipcl"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "pipcl" do
    url "https://files.pythonhosted.org/packages/1c/9d/d797318cf82fff625670bbbf88a722d87299c9d8f3fc8372603713ac0af4/pipcl-13.tar.gz"
    sha256 "286aba9785463c83659a565210a82a77896195d3303bff0542e825479b56daf2"
  end

  # Currently, some source of mujs is required for building mupdf, so can't use formula
  # Issue ref: https://bugs.ghostscript.com/show_bug.cgi?id=708968
  resource "mujs" do
    url "https://mujs.com/downloads/mujs-1.3.11.tar.gz"
    sha256 "456a395769daf110a30f9bf6f793044261e261481d5dca33b63cdc8714774ca4"

    # Resource `livecheck` blocks don't support package references (yet), so we
    # can't use `formula "mujs"` here.
    livecheck do
      url "https://mujs.com/downloads/"
      regex(/href=.*?mujs[._-]v?(\d+(?:\.\d+)+)\.t/i)
    end
  end

  deny_network_access!

  def install
    # Remove bundled libraries excluding `extract`, "strongly preferred" `lcms2mt` (lcms2 fork)
    # and `cmark-gfm` (mupdf builds against its private headers, so no system-lib option)
    keep = %w[cmark-gfm extract lcms2]
    (buildpath/"thirdparty").each_child { |path| rm_r(path) if keep.exclude? path.basename.to_s }

    # Install mujs from resource
    (buildpath/"thirdparty/mujs").install resource("mujs")

    # For python bindings needed by `pymupdf`: https://pymupdf.readthedocs.io/en/latest/packaging.html
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", dep("llvm").opt_prefix/site_packages

    (buildpath/"pipcl").install resource("pipcl")
    ENV.prepend_path "PYTHONPATH", buildpath/"pipcl/src"
    (buildpath/"packaging").install resource("packaging")
    ENV.prepend_path "PYTHONPATH", buildpath/"packaging/src"

    args = %W[
      build=release
      shared=yes
      tesseract=yes
      verbose=yes
      prefix=#{prefix}
      pydir=#{prefix}/#{site_packages}
      CC=#{ENV.cc}
      USE_SYSTEM_LIBS=yes
      USE_SYSTEM_MUJS=no
      VENV_FLAG=
    ]

    # Build only runs pkg-config for libcrypto on macOS, so help find other libs
    if OS.mac?
      [
        ["FREETYPE", "freetype2"],
        ["GUMBO", "gumbo"],
        ["HARFBUZZ", "harfbuzz"],
        ["LEPTONICA", "lept"],
        ["LIBJPEG", "libjpeg"],
        ["OPENJPEG", "libopenjp2"],
        ["TESSERACT", "tesseract"],
      ].each do |argname, libname|
        cflags = Utils.safe_popen_read("pkgconf", "--cflags", libname).strip
        args << "SYS_#{argname}_CFLAGS=#{cflags}"
        libs = Utils.safe_popen_read("pkgconf", "--libs", libname).strip
        args << "SYS_#{argname}_LIBS=#{libs}"
        args << "HAVE_SYS_#{argname}=yes"
      end

      # Workarounds since build scripts for Python bindings don't support macOS
      # Issue ref: https://bugs.ghostscript.com/show_bug.cgi?id=705376
      inreplace "Makefile" do |s|
        # Avoid creating a symlink that overwrites installed file
        s.gsub!(/^\s*ln -sf libmupdf/, "#\\0")

        # FIXME: libmupdfcpp should be a shared lib (.dylib) while _mupdf should be a bundle
        # (.so) as the former is a C++ library installed into `lib` while latter is loaded by
        # Python bindings. However, the python build scripts hardcode `.so` and uses `-shared`
        # which result in neither being correct. Also, the Makefile installs with $(SO) which
        # fails to find `.so`. For now we do the easier workaround of installing as `.so`.
        s.gsub! "libmupdfcpp.$(SO)", "libmupdfcpp.so"
        s.gsub! "_mupdf.$(SO)", "_mupdf.so"
      end

      ENV.append "CXX", "-std=c++14"
    end

    # Missing rpath for python bindings on macOS
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}" if OS.mac?

    system "make", "install", *args
    system "make", "install-shared-python", *args

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"

    lib.install_symlink lib/shared_library("libmupdf") => shared_library("libmupdf-third")
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
