class Libnpupnp < Formula
  desc "C++ base UPnP library, derived from Portable UPnP, a.k.a libupnp"
  homepage "https://www.lesbonscomptes.com/upmpdcli/npupnp-doc/libnpupnp.html"
  url "https://www.lesbonscomptes.com/upmpdcli/downloads/libnpupnp-6.3.2.tar.gz"
  sha256 "eedf9d9d05d048f88200d5226db065c16f7dcc2e3baefb0fed823185fa3fc024"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://framagit.org/medoc92/npupnp.git", branch: "master"

  livecheck do
    url "https://www.lesbonscomptes.com/upmpdcli/downloads/"
    regex(/href=.*?libnpupnp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "a768a594ef548962459672959c664adca0712ac554fb56186fa4c1c39041abc7"
    sha256 cellar: :any, arm64_golden_gate: "2c4028fae8cf4dd3dd0cb509f8648f8692439ed60df8edacc5b40a4be5376fba"
    sha256 cellar: :any, arm64_tahoe:       "0780a3e3b7b65755da1d6a75f3e9dc400b1d6201f2135365ea83045f86106af4"
    sha256 cellar: :any, arm64_sequoia:     "68b8e8af5de23debfca2d81c53493568bbf15550fff6192dd8f90f43f0dfdf15"
    sha256 cellar: :any, arm64_linux:       "1c46d587a93f1954990839583aca215c961ad52ce1b5eef33b9bd01ce75e37b0"
    sha256 cellar: :any, x86_64_linux:      "7653c5d8fa2cad066a6f8d67965e7e98c7caf04e62b85a8fc58912cb654dbe21"
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
