class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "106cfba7aba91faccb158e1c12a4a7c4c65adc95aa1f81b76b987882a68c5afb"
  license "GPL-2.0-or-later" => { with: "x11vnc-openssl-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b8966dae30c62b989afbce561e83e908a0f1212240b0b712b6a45f527465d242"
    sha256 cellar: :any,                 arm64_sequoia: "3177cd358897b8441de21ac9b2e0bacd75247def6243636fe74ac84713068c1e"
    sha256 cellar: :any,                 arm64_sonoma:  "641689b0921e831d369f6d554ecbcb0aca979f9334f031308273ec46139d91fe"
    sha256 cellar: :any,                 sonoma:        "adaf39d075bdceaa060d02243aeaa6b421be9f445bd294e5051a89edc200c888"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "210143a9eedf7cc165a1d0649fe6cf81f495e4d72f7babd38aa7ca41e8533801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c36c3ff46390d99f522ddd63de1dcad4e881b2025bd0af0639f15b11645b4d"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@4"

  # Backport support for OpenSSL 4
  patch do
    url "https://github.com/proxytunnel/proxytunnel/commit/69df6780b819a145ef11342a55d477a059333fe2.patch?full_index=1"
    sha256 "bf4b4fb8e68dde1a3c0124897de5a333b7f83cb321ecf04ea497867fb82d583e"
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
