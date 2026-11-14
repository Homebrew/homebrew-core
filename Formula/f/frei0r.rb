class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "5543917de48d2e8cc2fa02794240a3613447d00458bc2cf606aef20f4b8da515"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05cb8f77b9460ebb1c33eb25fd6940fb62f923b5edbf2a3a4da3697f9b3327f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77deddc2b5735ffaf736ce6c08ded0e7c35dd08089a1b34b344ea3c1ac19d401"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a52ae8e900b7ad897f674979afbd097894820d669ab27df5c3db7a179bc20561"
    sha256 cellar: :any,                 arm64_linux:       "5fc70b71dcce4f3944db6751ff095bfa239b9059194c0ec15e7b65eff6268caa"
    sha256 cellar: :any,                 x86_64_linux:      "afc6c673251dd32ae65587c380958beebaf794a7fabc86786defeb15cbed3671"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    # Skip the Linux-only `shadert0y` filter, which needs OpenGL/EGL from `mesa`
    inreplace "src/filter/CMakeLists.txt", "add_subdirectory (shadert0y)", ""

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
