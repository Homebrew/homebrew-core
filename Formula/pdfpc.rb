class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.4.1.tar.gz"
  sha256 "4adb42fd1844a7e2ab44709dd043ade618c87f2aaec03db64f7ed659e8d3ddad"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_ventura:  "1aace7c3c440270bc84311fe981b884ad25ef95124ff8bb20ad8e1987a0b48b6"
    sha256 arm64_monterey: "845616bcf0c462c48d7fe8560a990049cce37122a64f146048b2315b0a1c39eb"
    sha256 arm64_big_sur:  "1460cd4ac02aabc384a1ef9f63b80d39324f20599071b1b30bc658d38b79b97e"
    sha256 ventura:        "0db9b677c52f7918f1e880e732ab22dab9c497930540358cf8b5bbd1bbe4adaf"
    sha256 monterey:       "394fdad94e1359040ab98677190efe4088eb7ce722a12a256ac05a76447b14e3"
    sha256 big_sur:        "e9326d3ea690dc41682ff022c73798e14113b502779e295f737c62b2ccf74233"
    sha256 x86_64_linux:   "aa2f690eacb00966ce31538971a580c18fabbefd1c222ddc69918c83a396e561"
  end

  head do
    url "https://github.com/pdfpc/pdfpc.git", branch: "master"

    depends_on "discount"
    depends_on "json-glib"
    depends_on "libsoup@2"
    depends_on "qrencode"

    on_linux do
      depends_on "webkitgtk"
    end
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "poppler"

  def install
    # NOTE: You can avoid the `libsoup@2` dependency by passing `-DREST=OFF`.
    # https://github.com/pdfpc/pdfpc/blob/3310efbf87b5457cbff49076447fcf5f822c2269/src/CMakeLists.txt#L38-L40
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DMDVIEW=#{OS.linux?}", # Needs webkitgtk
                    "-DMOVIES=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Gtk-WARNING **: 00:25:01.545: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin/"pdfpc", "--version"
  end
end
