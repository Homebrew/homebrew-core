class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://github.com/Slackadays/Clipboard/archive/refs/tags/0.8.0.tar.gz"
  sha256 "d3fa16ee7fab364f9755d2a5991aaf06f7b6d703df7994486e7c424bfe1d97d2"
  license "GPL-3.0-or-later"
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "361cf7679d9f2e870b563454ba7ab174252dedf276d680e4dac6f063a4772103"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fea3506e04d5d5d6d74417d302d47038605c9c3760fae137c1ed0ce53765e4c4"
    sha256 cellar: :any_skip_relocation, ventura:        "4f6048004108c0052184a0f151ae7f1285324a528e886510992e5f714699befb"
    sha256 cellar: :any_skip_relocation, monterey:       "e3241512d5b1b3a139b5d0ef952c321eb09ba2bf851e5a9cca56295b38843eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92579fd2efdfbf38dce96218ad88c8497c96984d4eb2d29c53901c41c1ae4f99"
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
    system bin/"cb", "copy", test_fixtures("test.png")
    system bin/"cb", "paste"
    assert_predicate testpath/"test.png", :exist?
  end
end
