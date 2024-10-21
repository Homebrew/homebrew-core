class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.5.0/dav1d-1.5.0.tar.bz2"
  sha256 "a6ca64e34cec56ae1c2d359e1da5c5386ecd7a3a62f931d026ac4f2ff72ade64"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "445294270156e948f56f1e5ebea53b89edeb34e9781447cf30410a32eed6b9a5"
    sha256 cellar: :any,                 arm64_sonoma:  "9cccc1e358c7ace5deb5633c4bd28b13d4694f69a33592473a06836ae0604f42"
    sha256 cellar: :any,                 arm64_ventura: "9c8563cc40b59627ebe386f80a6bc571eb207e4695cc87614c2f149c0a0ceb77"
    sha256 cellar: :any,                 sonoma:        "9ff3e7327aee76d22e451a74649a143f1182c64898209dbffc286b4359e8504f"
    sha256 cellar: :any,                 ventura:       "29f4a35d228366348fad9c442c5ce244c946679048eb7b80fde7e145cbb97e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1e32051117de5bacb6aaddf73db231f7428b296aa7c9ccb80142f8405045bd9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "homebrew-00000000.ivf" do
      url "https://code.videolan.org/videolan/dav1d-test-data/raw/1.1.0/8-bit/data/00000000.ivf"
      sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
    end

    testpath.install resource("homebrew-00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end
