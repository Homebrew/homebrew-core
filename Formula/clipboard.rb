class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://github.com/Slackadays/Clipboard/archive/refs/tags/0.5.0.tar.gz"
  sha256 "4ef29040b871c8d6238408e61a569b0a41609398e0360ab375b9a32be062de81"
  license "GPL-3.0-or-later"
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bd6aef2dc310623b6906be1968dc299ddadaa364188d4f2a64df2e82e054545"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61491b0a060fd2732127787de673bc0c00906749a086f84ef0aba2e18cc06c4d"
    sha256 cellar: :any_skip_relocation, ventura:        "96bc833d527f1cbbea874f363975cce3a651d21a262a30e6c53c72bcf24bb5c9"
    sha256 cellar: :any_skip_relocation, monterey:       "9bb8f31c692869e912f538103289d06ba9ce3c0c1f8f721fddcec485ba8eff9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b66cea8207e127e1b499c1d062ffc62db5fa4fd662da8c50684acc672e565eb"
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
