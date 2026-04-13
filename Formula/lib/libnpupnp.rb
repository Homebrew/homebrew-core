class Libnpupnp < Formula
  desc "C++ base UPnP library, derived from Portable UPnP, a.k.a libupnp"
  homepage "https://www.lesbonscomptes.com/upmpdcli/npupnp-doc/libnpupnp.html"
  url "https://www.lesbonscomptes.com/upmpdcli/downloads/libnpupnp-6.3.0.tar.gz"
  sha256 "082d999178291ed45ae24c3fd9e781120d3ec94d61d11121e5bac90c69365cda"
  license "BSD-3-Clause"
  head "https://framagit.org/medoc92/npupnp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "141b316ada0746285ff9a60a7dc2c50437b1ea741060ec3a5e59200c92b1e6c2"
    sha256 cellar: :any, arm64_sequoia: "3f4a7e43041ff717d6e88c893aa0dd62085aebd53a0e2e406bcab3a510f15cb4"
    sha256 cellar: :any, arm64_sonoma:  "ca8a751ce725212d714e7a7391c32ced32d704745f9cc6d4a350b1242df93eca"
    sha256 cellar: :any, sonoma:        "9a70d482ade51403f72493297d03b5a554eccd60d06d9c4fdf80b4f36641710a"
    sha256               arm64_linux:   "c57d0db7317e803bf566e234baaf178cdd14b6263091973b67e7895c677309e9"
    sha256               x86_64_linux:  "0c9a6ac376600e8456a7fcd6254216a3b80a721a691899b7ef8488ef370a9671"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"

  uses_from_macos "curl"
  uses_from_macos "expat"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "test/test_init.cpp"
  end

  test do
    system ENV.cxx, "-std=c++17", pkgshare/"test_init.cpp", "-o", "test",
                    "-I#{include}/npupnp", "-L#{lib}", "-lnpupnp"
    output = shell_output("./test")
    assert_match "NPUPNP_VERSION_STRING = \"#{version}\"", output
    assert_match "UPnP Initialized OK", output
  end
end
