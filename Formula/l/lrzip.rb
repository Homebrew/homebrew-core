class Lrzip < Formula
  desc "Compression program with a very high compression ratio"
  homepage "https://github.com/ckolivas/lrzip"
  url "https://github.com/ckolivas/lrzip/releases/download/v0.7.3/lrzip-0.7.3.tar.xz"
  sha256 "6928862de7c4bbb3cfbcd12fae9fd0a7d230d5bbf27486e52c4de60717ebfdbb"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/ckolivas/lrzip.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "362516d2494e681dc09b48a98e65c0179e8d46e3f916fab36b99b9a9f253096c"
    sha256 cellar: :any, arm64_tahoe:       "c60886621285783f3fbaf0b0ecff0b51b16713d5df53c38f816b30f785d79527"
    sha256 cellar: :any, arm64_sequoia:     "7855750161fc71e8b46e14d1b853a989819b8b58819a3061ce75f1c8e1aa9171"
    sha256 cellar: :any, arm64_linux:       "d1771a884151c6c9ad11bc37134f9ab481dc2a4d4090e5907f690b6159b4ac81"
    sha256 cellar: :any, x86_64_linux:      "cf6eed8d9ef3d17c9204d4df6f4548c23041f529d0d443a5326b8e3b171352fa"
  end

  depends_on "lz4"
  depends_on "lzo"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "lrzsz", because: "both install `lrz` binaries"

  def install
    system "./configure", *std_configure_args
    system "make", "SHELL=bash"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lrz
    system bin/"lrzip", "-o", "#{path}.lrz", path
    path.unlink

    # decompress: data.txt.lrz -> data.txt
    system bin/"lrzip", "-d", "#{path}.lrz"
    assert_equal original_contents, path.read
  end
end
