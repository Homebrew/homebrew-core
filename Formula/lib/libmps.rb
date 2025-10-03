class Libmps < Formula
  desc "Memory Pool System"
  homepage "https://www.ravenbrook.com/project/mps/"
  url "https://github.com/Ravenbrook/mps/archive/refs/tags/release-1.118.0.tar.gz"
  sha256 "58c1c8cd82ff8cd77cc7bee612b94cf60cf6a6edd8bd52121910b1a23344e9a9"
  license "BSD-2-Clause"
  head "https://github.com/Ravenbrook/mps.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c615224288aff51fe425cc3ab91473dbf05f95391c883ca5764e0de227992891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c651514f2ee9c277517272b328db0e41ab0cc06b3998302e591db274dc70f104"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c076fea0e44ca8cf0aacfc914e05a8d4af972c32700d11ce60a4858c6270f96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc6283eb82ae52dc677b701a27f47146c4613c820b32d877b9ec52536f51474e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6b18ffb9d46a689f2888c158cb44d1e5bc9a355eb55265b6668a6c19e1000c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e29c7675afe66148b0f8f80b451815db76d96e01bf2199045f632a096bc56e6"
    sha256 cellar: :any_skip_relocation, ventura:        "ea7bb763c29bf43202b04fcd59bc1d16797983f1b0f52623cee8f04638893a26"
    sha256 cellar: :any_skip_relocation, monterey:       "f5b350ecbd4ab59b60427487a720c13ebb86075860008a49e74d44529c05fecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5a383edbaa3b70a087af6f5eafeb264f7d95477d71d8b9c354c9df970eebe45a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54043c0fcf718172a1d9f20e9eae7287180d26f4306f652c19f3d460faf68e9"
  end

  depends_on xcode: :build

  def install
    if OS.mac?
      # macOS build process
      # for build native but not universal binary
      # https://github.com/Ravenbrook/mps/blob/master/manual/build.txt
      xcodebuild "-scheme", "mps",
                 "-configuration", "Release",
                 "-project", "code/mps.xcodeproj",
                 "OTHER_CFLAGS=-Wno-error=unused-but-set-variable -Wno-unused-but-set-variable"

      # Install the static library
      lib.install "code/xc/Release/libmps.a"

      # Install header files
      include.install Dir["code/mps*.h"]

    else
      ENV.deparallelize
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include "mps.h"
      #include "mpscawl.h"
      #include "mpscamc.h"
      #include "mpsavm.h"

      int main() {
        mps_arena_t arena;
        mps_res_t res = mps_arena_create(&arena, mps_arena_class_vm(), 1024*1024);
        return (res == MPS_RES_OK) ? 0 : 1;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmps", "-o", "test"
    system "./test"
  end
end
