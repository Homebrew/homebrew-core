class Libnpupnp < Formula
  desc "C++ base UPnP library, derived from Portable UPnP, a.k.a libupnp"
  homepage "https://www.lesbonscomptes.com/upmpdcli/npupnp-doc/libnpupnp.html"
  url "https://www.lesbonscomptes.com/upmpdcli/downloads/libnpupnp-6.2.3.tar.gz"
  sha256 "563d2a9e4afe603717343dc4667c0b89c6a017008ac6b52262da17a1e4f6bb96"
  license "BSD-3-Clause"
  head "https://framagit.org/medoc92/npupnp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3278ce2a5a291e0f2d28f022453d0577a57f5071e4bc3bc2cfe3de8591a84627"
    sha256 cellar: :any, arm64_sequoia: "41e44bcf67f2071457128e58931324c0af086c9942a66687a2d59f2458ef31fd"
    sha256 cellar: :any, arm64_sonoma:  "39ba90edb2366733796e84d222bb0bf71e74c27c7f4471a8e7441e285880fba6"
    sha256 cellar: :any, sonoma:        "d26a799d4eb9e425b424fb7b19195127889ca06cb0968a776e670b84ee75819f"
    sha256               arm64_linux:   "ed47a43b39a4091cbc93abf7395cdfce37bf2ea946f716e74aa9a24ba0669290"
    sha256               x86_64_linux:  "848948583f1484beb7d5084457f8083d5408eb7027b48666bcf6d2d48223b171"
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
