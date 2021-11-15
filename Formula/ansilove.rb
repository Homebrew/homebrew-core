class Ansilove < Formula
  desc "ANSI/ASCII art to PNG converter"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/ansilove/releases/download/4.1.5/ansilove-4.1.5.tar.gz"
  sha256 "dcc6e82fab1587a0f556ee64a6cda9c91dcaaa37306cccc4a4d25f7c96b04d19"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8153bad43ca6f245a5266ada677be1b53a6aa3436113849360ea7f28eefd723a"
    sha256 cellar: :any,                 arm64_big_sur:  "ce746bff57bf9c61f3dae89126257d741593d68587d740f7267ef5e1b2a3a111"
    sha256 cellar: :any,                 monterey:       "95fbd757366e5ec61fb261941e109d8e5462d82c84dd9e174da73ff7bc83e074"
    sha256 cellar: :any,                 big_sur:        "6b82fee266c64e4738ebef22c745f3a457dccad114a285bc85972651c2545c26"
    sha256 cellar: :any,                 catalina:       "78487b299437decd72a5a2152caf81ba4997e9300016032ed449981cfc174641"
    sha256 cellar: :any,                 mojave:         "d40386a9e4ab3b22d87f894f1a018bd481592c26792fe95ea86fc918e4f3c26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f25e133bbae1b11f1422da43fd27da11bf42cd3d2caf68e92024143726d24d02"
  end

  depends_on "cmake" => :build
  depends_on "gd"

  resource "libansilove" do
    url "https://github.com/ansilove/libansilove/releases/download/1.2.8/libansilove-1.2.8.tar.gz"
    sha256 "ef02eda605e3b38edbeac5874f2de22201db123cb7aab9228fd05cb288d0c0bc"
  end

  def install
    resource("libansilove").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/burps/bs-ansilove.ans" => "test.ans"
  end

  test do
    output = shell_output("#{bin}/ansilove -o #{testpath}/output.png #{pkgshare}/test.ans")
    assert_match "Font: 80x25", output
    assert_match "Id: SAUCE v00", output
    assert_match "Tinfos: IBM VGA", output
    assert_predicate testpath/"output.png", :exist?
  end
end
