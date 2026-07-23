class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "1b1ae36327254cac351aa5358767c177b050ab4ce4a75fa100244da7816849e9"
  license "GPL-2.0-or-later" => { with: "x11vnc-openssl-exception" }

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5eeebf767f77ae0008d4dd0f6e9537d11d4dc4df5e799e1fb86b5fe428383cbd"
    sha256 cellar: :any, arm64_sequoia: "4d3d58b0f4961547187ad3aa9ebd2ab3cff42cbfcf9305b6da4dfc164f7deb6d"
    sha256 cellar: :any, arm64_sonoma:  "3b0c5fff82ba280f682abc7a871bf0dd1ff221ac623c256f56a59be2d430bb30"
    sha256 cellar: :any, sonoma:        "17855bc805686e63ed5fa8801c9f25080a76283913a98676a4172308486587b8"
    sha256 cellar: :any, arm64_linux:   "48c5fe0955edcf6c838dd768ca836fa09f45357c681f001b0ab884933935c0af"
    sha256 cellar: :any, x86_64_linux:  "22a1905c09b257f1d5992116b14fe7edfe3a26205f6d5b4bc5c12bbb325d67f5"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@4"

  # Backport support for OpenSSL 4
  patch do
    url "https://github.com/proxytunnel/proxytunnel/commit/69df6780b819a145ef11342a55d477a059333fe2.patch?full_index=1"
    sha256 "bf4b4fb8e68dde1a3c0124897de5a333b7f83cb321ecf04ea497867fb82d583e"
    type :backport
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"proxytunnel", "--version"
  end
end
