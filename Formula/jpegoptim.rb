class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/v1.5.0.tar.gz"
  sha256 "67b0feba73fd72f0bd383f25bf84149a73378d34c0c25bc0b9b25b0264d85824"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpegoptim.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e6d9c5e8553dc145485bf7ac4f51769fa784db83a3a9c32f1a3104efe44ce7b4"
    sha256 cellar: :any,                 arm64_big_sur:  "3a86e5222a263e8839fa4cc5a1718867db725fbb586c9a835aab536f4c61ccbb"
    sha256 cellar: :any,                 monterey:       "63e2cf66cd28f76ba91fe51e9b48aa41355c87376469305a39caa2597b5af576"
    sha256 cellar: :any,                 big_sur:        "cd7e4b0eebb6a3ea8f46012f34e18631efe9e5d966d7c09d8ca3bddb74802285"
    sha256 cellar: :any,                 catalina:       "f3cea036b0c5dd14edadeb0e809add5fb2dd9cca19dceafa5cfb990a336942b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58ce46f0434d04bb363eb84e89a9043c429163733a502716db6e1f7b52afdbf2"
  end

  depends_on "jpeg-turbo"

  def install
    system "./configure", *std_configure_args
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
