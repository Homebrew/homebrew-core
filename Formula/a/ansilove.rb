class Ansilove < Formula
  desc "ANSI/ASCII art to PNG converter"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/ansilove/releases/download/4.2.3/ansilove-4.2.3.tar.gz"
  sha256 "18ff3eb554860a7af8b0627f21ee409d30d9552ce650532dd173183fb69e0b42"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f0a4c36ac41dee4c04977ac2a7296bfd055042c6c91462baa21fc75f2a36f7ed"
    sha256 cellar: :any, arm64_tahoe:       "6db266f4198b640a5f9882f920d23df9ae5bdeef6d333b99e0021e441c0b0ed6"
    sha256 cellar: :any, arm64_sequoia:     "c0420df63dd7807eeb8196584be6d024dc9bc2a682fc0fcea8ed786e065f7b49"
    sha256 cellar: :any, arm64_linux:       "ff50cd27756549977334048de13f3d105caf14a945bb10edee5af9b7eaaaa334"
    sha256 cellar: :any, x86_64_linux:      "828d37e6d8ccdd4ac8332e4c1bb06142709271dcf4e2965bc7887e1a3ea57f44"
  end

  depends_on "cmake" => :build
  depends_on "libansilove"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/burps/bs-ansilove.ans" => "test.ans"
  end

  test do
    output = shell_output("#{bin}/ansilove -o #{testpath}/output.png #{pkgshare}/test.ans")
    assert_match "Font: 80x25", output
    assert_match "Id: SAUCE v00", output
    assert_match "Tinfos: IBM VGA", output
    assert_path_exists testpath/"output.png"
  end
end
