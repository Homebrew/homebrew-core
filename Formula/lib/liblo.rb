class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.33/liblo-0.33.tar.gz"
  sha256 "772edd51e5809b72413d5de7fc10422e70b08a7ffd5b0e924f555de1319accde"
  license "LGPL-2.1-or-later"
  head "https://git.code.sf.net/p/liblo/git.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36ed69df98dc612645558e42fc2c631037960e093fefc883a22a627c558e9e9f"
    sha256 cellar: :any,                 arm64_sequoia: "05d58b3c3088072d0f20624812d333e281549071b43a29f098cdf83a4d73c68c"
    sha256 cellar: :any,                 arm64_sonoma:  "bb240abb61650d49326765c0fe553e63f1ce0d1894f0cb0e2dba9a9d7e816592"
    sha256 cellar: :any,                 sonoma:        "81b9be048f731ae09ecb6d3b6d61c07254f14604753d46da6d3d411014c9a8b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8a711b483ee995ce89fed162727d52d86b380eb874809a1b1aa608ee17dd479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0b860801c05b95f768202b295ef2c1e82555ca4469d08c98113bb0f910318a4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "cmake", "-B", "cmake_build", *std_cmake_args
    system "cmake", "--build", "cmake_build"
    system "cmake", "--install", "cmake_build"
  end

  test do
    (testpath/"lo_version.c").write <<~C
      #include <stdio.h>
      #include "lo/lo.h"
      int main() {
        char version[6];
        lo_version(version, 6, 0, 0, 0, 0, 0, 0, 0);
        printf("%s", version);
        return 0;
      }
    C
    system ENV.cc, "lo_version.c", "-I#{include}", "-L#{lib}", "-llo", "-o", "lo_version"
    assert_equal version.to_str, shell_output("./lo_version")
  end
end
