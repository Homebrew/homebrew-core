class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v2.6.0/libfabric-2.6.0.tar.bz2"
  sha256 "1ee2ab6eb16462c0fe7a836f9df52b8f12309dfee3f3774aa93a86f521a8e8b1"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f5c27820d3d5ab09cc1b6dedb83d9130e0ad4681b0394a03d89207c36532b229"
    sha256 cellar: :any, arm64_sequoia: "0a5d94acf1897471bda1d148fbc898aba833dd61f1ba8afdf8a2b26e8d2fcd8c"
    sha256 cellar: :any, arm64_sonoma:  "ce609666bd9a47dec6ff1ddba8029797b17b9f3cdca9bcaa5d940b7e85a3c9db"
    sha256 cellar: :any, sonoma:        "5c1d12aa2aeda2bbda52c62cc3333ab1606cb1b6315041ef64e0c3fb5418f6b2"
    sha256 cellar: :any, arm64_linux:   "a49929c131b79248a953bd13324f41f7c5285702cf81f20150b3fcfe28df7c1c"
    sha256 cellar: :any, x86_64_linux:  "ae5a82abd6528b7b146eb3812aa7dcb47acbfd6ed6f2c70963b3596173d1821b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
