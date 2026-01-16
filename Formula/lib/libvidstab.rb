class Libvidstab < Formula
  desc "Transcode video stabilization plugin"
  homepage "https://github.com/georgmartius/vid.stab"
  url "https://github.com/georgmartius/vid.stab/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9001b6df73933555e56deac19a0f225aae152abbc0e97dc70034814a1943f3d4"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "92e26eba0998b49ac6c3e2b5111e59007df158ffe697af89ed427c1f1fe7be0c"
    sha256 cellar: :any,                 arm64_sequoia:  "f76b62fb9580b75861cc5a6d639500d095823d32bef7aa6f636fee2d87b724e9"
    sha256 cellar: :any,                 arm64_sonoma:   "f006d60e59a43562474571f2a7e2be72273cc9bd7b2df04d0c21da861ebfcab8"
    sha256 cellar: :any,                 arm64_ventura:  "25efabe3bf9a85b25065758c1ea62ef096bf2e334ce073450ef4478f7e469b38"
    sha256 cellar: :any,                 arm64_monterey: "0bff0aa6aba039cc22d6a65fbfd46f67c35ecc6db3baca439b9b1e45c3710002"
    sha256 cellar: :any,                 arm64_big_sur:  "bca6a787bd17369819451093009d298fc8a4104be1d9bd25bd9606263d097784"
    sha256 cellar: :any,                 sonoma:         "4263aef306ed5a576474d9101d8a75afc7c8e39f68a783940a81ae9fb772fe67"
    sha256 cellar: :any,                 ventura:        "40cc585d8dfe08ddb7938667997fac65cd96261f9699c4d7a1705e30267cdb61"
    sha256 cellar: :any,                 monterey:       "8caa0dce4af772a443f814f51960227e769428025f734a9a82085fc8ee499ef9"
    sha256 cellar: :any,                 big_sur:        "2b7d9891009c53a925e971b600bad2a43e5bcca062119b9080e1c5b59e2e25b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4cd7955f3da1c7f0c168790291b6c93d4144593c5b351e9caec0ab0d69992aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d87451266aa81a807919bb25dec5cb85e2e79eca8fa768dba8c7b74f06e11be9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  def install
    args = %w[
      -DUSE_OMP=OFF
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <vid.stab/libvidstab.h>
      #include <stdio.h>
      int main() {
        printf("libvidstab version: %s\\n", LIBVIDSTAB_VERSION);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs vidstab").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
