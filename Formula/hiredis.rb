class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v1.1.0.tar.gz"
  sha256 "fe6d21741ec7f3fc9df409d921f47dfc73a4d8ff64f4ac6f1d95f951bf7f53d6"
  license "BSD-3-Clause"
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aec608b16fd0a7add69a6f1d80a832cda709fb6dfa115f59e3cde8b131ff0687"
    sha256 cellar: :any,                 arm64_monterey: "e499ad54baf866fd665c1160db82f235cd9cb84f8ae369f0be4a14a52e81eae0"
    sha256 cellar: :any,                 arm64_big_sur:  "95224205d629a4e8715c1e66d722cb580ccd4c78ce5e943f70cd8bde0021e641"
    sha256 cellar: :any,                 monterey:       "61d0cc662645452391544eaed8720a8043d65ed742a6119166d6b6d98ea62a3f"
    sha256 cellar: :any,                 big_sur:        "5cbf446863123927636711ced21b342fa66568de9b25ec793fd54d3b3b53ca41"
    sha256 cellar: :any,                 catalina:       "14ae7b3adb354b673a3744e9d849d6698846d5162d3d5f0eb8f9d8837c858e75"
    sha256 cellar: :any,                 mojave:         "050805a747642516f0b8a9573f2b2935de26089b7f0380b84f6f8a6e4ab41b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93cdd4749c4f2c4d3862de2a7bacd687a7900c9b3343b9a69ef163b16d3b0e94"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, pkgshare/"examples/example.c", "-o", testpath/"test",
                   "-I#{include}/hiredis", "-L#{lib}", "-lhiredis"
    assert_predicate testpath/"test", :exist?
  end
end
