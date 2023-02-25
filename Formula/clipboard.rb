class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://github.com/Slackadays/Clipboard/archive/refs/tags/0.4.0.tar.gz"
  sha256 "ff4ebccdde9800d064b0c92fa4206770a5bf64826f0a0566416a7f3e6cedf997"
  license "GPL-3.0-or-later"
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e5e31417b447abae3fc5f894f44d8f91cbca6437200ee268d7c0a9fdcfe0ef8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80a55860d2a5cae77caf4ee411bb475b4c4964d115258c9e24f652fc04fc6628"
    sha256 cellar: :any_skip_relocation, ventura:        "bd37f12d2857e2796e95a7a826e407976da9482c4b2457a64baa2bc1c13d3424"
    sha256 cellar: :any_skip_relocation, monterey:       "30c672dffc025e258f3fe09873668e5069c36fdccd71fb611481dd22914d4a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "306606b0588bee5288dc88a1df28e210fccc541d504bcfc34b5bce57628908df"
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
