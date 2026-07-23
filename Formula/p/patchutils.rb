class Patchutils < Formula
  desc "Small collection of programs that operate on patch files"
  homepage "https://cyberelk.net/tim/software/patchutils/"
  url "https://github.com/twaugh/patchutils/releases/download/0.4.5/patchutils-0.4.5.tar.xz"
  sha256 "8386a35a4d2d3cbc28fdcc93c5be007c382c78e3ee079070139f0d822e013325"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f73c0a54e3ea11391794dac98bbe16d0d0a476205940e2b7545065c7efe2f2c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9447a395cc82a522c7d7235db4a3bebb1643ce14630f4365754cfa8c9ddbc7fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74d12639f80f9eb681b781871e64342b8ee1b7b8d39edddb7c4351a97040550e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b137f453b90ca585d0041a05422cf0eb30899304d0eb27aae6c297148a38a40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e8ab3deffa04e3b0a40cb52338ab71c5434e0e5697ef45c2fdcfb5f12bf6d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e53f763da7310b7c7a1c223e3ff7118fbb67d0fd7c45e90e058d8ae56d90898f"
  end

  head do
    url "https://github.com/twaugh/patchutils.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook" => :build
  end

  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./bootstrap" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match %r{a/libexec/NOOP}, shell_output("#{bin}/lsdiff #{test_fixtures("test.diff")}")
  end
end
