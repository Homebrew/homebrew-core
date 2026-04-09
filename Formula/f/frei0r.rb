class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "a206f16564d5c506cef8919e398bb568f69e2eaf7c2f0908043c0fb4db6aab50"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8708231f327ab08c4a1b9fc702087f9920e841ca5507b9bb823f10e61fb4d88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f5c0650c05eef5cd067f20c9faac02641be7d3c7004e767d3f50bcfcf590708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08e625e4bc9c55687930ea784ac11d3c924fa170fbb08d24b17545be293fed7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "23f9e82cb17a5843d2bebb28a7041b8408110e6855566e3444f630dd736668e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e820c564ba71a55b195ca3530a324467fd718c6398be1e9742c1e55b0a74a74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bae7f9e28678e97f27439aa24df873267460dea2e32aa9fb49f07e63aa6a4556"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
      -DWITHOUT_CAIRO=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    C
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end
