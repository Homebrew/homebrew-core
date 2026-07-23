class Libmonome < Formula
  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/refs/tags/v1.4.10.tar.gz"
  sha256 "b2684d790da645948bf7f5bbd997f241567e67c8269d7361006cafa1c9bdad92"
  license "ISC"
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5d780da58b7c74eff9bff8d785e09ee6337e1bd0110f64c8b56d1f0a4ada16f"
    sha256 cellar: :any,                 arm64_sequoia: "7413e13d1540f8a4dd02efd21158343a56ce2ce0a08a26c87fac4ce907f3f352"
    sha256 cellar: :any,                 arm64_sonoma:  "731bdc3bbf8cd9c3bb2b77a591a00769a40732cf10ed96a496c0472f7f7b905e"
    sha256 cellar: :any,                 sonoma:        "a842a34f619967b87993662603ea4377b0ccdb336eae88aa3b523afed6eff1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9149a77bd63d1d429ca394cc345f14545e01fd34ed8e02b3d21487477d057151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98ca9e32707506cfb8d3044b804f5151e29a8429048f540c956db65f23785c74"
  end

  depends_on "liblo"

  uses_from_macos "python" => :build

  def install
    # Workaround for arm64 linux, issue ref: https://github.com/monome/libmonome/issues/82
    ENV.append_to_cflags "-fsigned-char" if OS.linux? && Hardware::CPU.arm?

    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"

    pkgshare.install Dir["examples/*.c"]
  end

  test do
    assert_match "failed to open", shell_output("#{bin}/monomeserial", 1)
  end
end
