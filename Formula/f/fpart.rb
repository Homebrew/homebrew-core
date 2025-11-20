class Fpart < Formula
  desc "Sorts file trees and packs them into bags"
  homepage "https://github.com/martymac/fpart/"
  url "https://github.com/martymac/fpart/archive/refs/tags/fpart-1.7.0.tar.gz"
  sha256 "e5f82dd90001ed53200b2383bcfd520b1d8ee06d6a2a75b39d37d68daef20c88"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "150c62d9d4e4573e9e57877aceb72d7044f25f1f104a0037d888af51464f748e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62e4da1fc98b89c57755a274ab68045d982e784ddec2a77a4d9f0243947672cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02ff854bb224beaa872d0bea7b8128a812f31a902b0469341b4c4562cabf5ce2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1911af8d359c21a98d9c7337f2a1ecedfcb26f58c1b52087b12c4cf0a0980fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c40ec263a1dd6321e2878cc65d6f22c372a7b7846ca2a42c29068dbf41e7ccb"
    sha256 cellar: :any_skip_relocation, ventura:       "bbb63a308a1a001f6accf2c86294a5c04a3ae5ab2517cf45549108530a0c6b05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98050183e715d54e94a44254546c227475622fa4a7dc6e73eb96fbbb88486bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52fa28e8ae55c6595258e13f8ee9f093225f1cbed462cbaaa4171571f884cd5d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"myfile1").write("")
    (testpath/"myfile2").write("")
    system bin/"fpart", "-n", "2", "-o", (testpath/"mypart"), (testpath/"myfile1"), (testpath/"myfile2")
    assert_path_exists testpath/"mypart.1"
    assert_path_exists testpath/"mypart.2"
    refute_path_exists testpath/"mypart.0"
    refute_path_exists testpath/"mypart.3"
  end
end
