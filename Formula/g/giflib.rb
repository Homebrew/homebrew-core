class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-6.x/giflib-6.1.2.tar.gz"
  sha256 "2421abb54f5906b14965d28a278fb49e1ec9fe5ebbc56244dd012383a973d5c0"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/giflib[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47c053a47ffdb60efe8a86e42f3ebfd0790630c8e209c76abbc1301aea7af33b"
    sha256 cellar: :any,                 arm64_sequoia: "ab9ea92328ff025c3c50a2f5be370d2cd970fe31b746417a9bae99fa038e6a46"
    sha256 cellar: :any,                 arm64_sonoma:  "3046550c4e6e7525239c20798fb090acf521361134224ccee4f24dce975b28df"
    sha256 cellar: :any,                 sonoma:        "01044b2d4051eeeb8acc4ae16f017b74df7adc0fdfd77d9d1f3d8b3b5e97bc5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fcdfe49c9fb632dbcf4ffe4a6adbe98f19e7d36410a6ab398746a6b29c29934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6756c7d0bd5d9c0a3437288e4bd78cd1f05c4e13b27d17bdb4f5242dd4d8974"
  end

  def install
    args = ["PREFIX=#{prefix}"]
    # Manually skipping shared libutil due to https://sourceforge.net/p/giflib/bugs/189/.
    # It is currently unused (binaries link to libutil.a) and not installed.
    args << "LIBUTILSO=" if OS.mac?

    system "make", "all", *args
    ENV.deparallelize # avoid parallel mkdir
    system "make", "install", *args
  end

  test do
    output = shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
    assert_match "Screen Size - Width = 1, Height = 1", output
  end
end
