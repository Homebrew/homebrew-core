class Dxc < Formula
  desc "DirectX Shader Compiler for HLSL to DXIL and SPIR-V"
  homepage "https://github.com/microsoft/DirectXShaderCompiler"
  license "NCSA"

  head "https://github.com/microsoft/DirectXShaderCompiler.git", branch: "main"

  stable do
    url "https://github.com/microsoft/DirectXShaderCompiler/archive/refs/tags/v1.9.2602.tar.gz"
    sha256 "f95027d510600f87fb0071a3392a9a6590a726bc4b6e0aa42d06b3dbc39fca20"

    # Fix StringRef build with libc++ >= 19; drop on next upstream release.
    # https://github.com/microsoft/DirectXShaderCompiler/pull/8307
    patch do
      url "https://github.com/microsoft/DirectXShaderCompiler/commit/bacbfaa6600f602df5cc33632c2b08d1404c0319.patch?full_index=1"
      sha256 "61ecdbcdbf91219be6b0ae4a3306b9c569592c32ea89018855aaca710df30179"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => :build

  uses_from_macos "zlib"

  # Vendored to the exact submodule commits the release tag is built against;
  # DXC consumes them via add_subdirectory() with no find_package() codepath.
  resource "spirv-headers" do
    url "https://github.com/KhronosGroup/SPIRV-Headers/archive/04f10f650d514df88b76d25e83db360142c7b174.tar.gz"
    sha256 "1b220e3eec1714f0451b0e3652979bd280edf10893f617837b88e6359a804ded"
  end

  resource "spirv-tools" do
    url "https://github.com/KhronosGroup/SPIRV-Tools/archive/fbe4f3ad913c44fe8700545f8ffe35d1382b7093.tar.gz"
    sha256 "cabb35f4eef0da3ef72ad9edd596af4191d7507a8f35c05df526d2d5ff889f59"
  end

  resource "directx-headers" do
    url "https://github.com/microsoft/DirectX-Headers/archive/980971e835876dc0cde415e8f9bc646e64667bf7.tar.gz"
    sha256 "b5a4b6d8806ff7f29f19879f83d015dbe8740676d4ca0b48647a789cc7773c4e"
  end

  def install
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")
    (buildpath/"external/SPIRV-Tools").install resource("spirv-tools")
    (buildpath/"external/DirectX-Headers").install resource("directx-headers")

    args = %W[
      -C#{buildpath}/cmake/caches/PredefinedParams.cmake
      -DHLSL_INCLUDE_TESTS=OFF
      -DLLVM_INCLUDE_TESTS=OFF
      -DCLANG_INCLUDE_TESTS=OFF
      -DSPIRV_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "install-dxc", "install-dxcompiler", "install-dxc-headers"
  end

  test do
    (testpath/"shader.hlsl").write <<~EOS
      RWStructuredBuffer<float> Output : register(u0);
      [numthreads(1, 1, 1)]
      void main(uint3 id : SV_DispatchThreadID) {
        Output[id.x] = float(id.x) * 2.0;
      }
    EOS

    system bin/"dxc", "-T", "cs_6_0", "-E", "main", "-Fo", "shader.dxil", "shader.hlsl"
    assert_equal "DXBC", (testpath/"shader.dxil").binread(4)

    system bin/"dxc", "-spirv", "-T", "cs_6_0", "-E", "main", "-Fo", "shader.spv", "shader.hlsl"
    assert_equal "\x03\x02\x23\x07".b, (testpath/"shader.spv").binread(4)
  end
end
