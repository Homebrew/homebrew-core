class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://github.com/Slackadays/Clipboard/archive/refs/tags/0.5.0.tar.gz"
  sha256 "4ef29040b871c8d6238408e61a569b0a41609398e0360ab375b9a32be062de81"
  license "GPL-3.0-or-later"
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaa3dcda9c39c4aed64d21078caf5906f7bf4f8736d20ec6632256d4b5bd03a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8d9e49a0ab13bc9370d10613966f4f4f3709a4bf59bc664eacd3e310e664e17"
    sha256 cellar: :any_skip_relocation, ventura:        "42fee22cb2ea20ae12c49ce1a47de073522c618d8987a08c5344baa5f161c8d6"
    sha256 cellar: :any_skip_relocation, monterey:       "85ca33f032ccdf6da7db29a118502e1ace3408a3e0423e563832b84b4a893f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23c0caf06d5544b4494dd06df5513df904d7a9a6b738fce33826375016462cd1"
  end

  depends_on "cmake" => :build
  depends_on macos: :monterey

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "wayland-protocols" => :build
    depends_on "libx11"
    depends_on "wayland"
  end

  fails_with :clang do
    build 1300
    cause "Requires C++20 support"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CLIPBOARD_FORCETTY"] = "1"
    ENV["CLIPBOARD_NOGUI"] = "1"
    system bin/"clipboard", "copy", test_fixtures("test.png")
    system bin/"clipboard", "paste"
    assert_predicate testpath/"test.png", :exist?
  end
end
