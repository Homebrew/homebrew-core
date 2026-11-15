class Libnpupnp < Formula
  desc "C++ base UPnP library, derived from Portable UPnP, a.k.a libupnp"
  homepage "https://www.lesbonscomptes.com/upmpdcli/npupnp-doc/libnpupnp.html"
  url "https://www.lesbonscomptes.com/upmpdcli/downloads/libnpupnp-6.3.1.tar.gz"
  sha256 "1e6271dd2e641a5b095d994be6976031e5f6b32a22df3bb1988636f51b0f52b7"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://framagit.org/medoc92/npupnp.git", branch: "master"

  livecheck do
    url "https://www.lesbonscomptes.com/upmpdcli/downloads/"
    regex(/href=.*?libnpupnp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fa9c584e2e1f01f12ac1e3aca0b018fb59017463606f4188c1bbfe4e87e065ad"
    sha256 cellar: :any, arm64_tahoe:       "0f4a521d1f73de529303c5cb37a880367eb448717668159a353970582decbef7"
    sha256 cellar: :any, arm64_sequoia:     "e10f1fde2bcab43fcc4fd4374b80ce56ba46f98d8e9ba960c4c88f09c3c1b88d"
    sha256 cellar: :any, arm64_linux:       "1a5d36f6b7edfc79cb3a4373e20ddf400973572aa3b6bf9f70cac8811f098183"
    sha256 cellar: :any, x86_64_linux:      "d8a18602a14cc31b3237f8b73ccc3119eb3e234a8181b85d7b1534be433e1a2a"
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
