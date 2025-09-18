class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  license "Apache-2.0"
  revision 2
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  stable do
    url "https://github.com/MaskRay/ccls/archive/refs/tags/0.20241108.tar.gz"
    sha256 "76224663c3554eef9102dca66d804874d0252312d7c7d02941c615c87dcb68af"

    # Backport support for LLVM 20
    patch do
      url "https://github.com/MaskRay/ccls/commit/4331c8958698d42933bf4e132f8a7d61f3cedb8c.patch?full_index=1"
      sha256 "5420b53cf912268688953a2863e86f6b88334ed548852eaedb9f8ce4871ee034"
    end

    # Backport reformat commit to cleanly apply later patches
    patch do
      url "https://github.com/MaskRay/ccls/commit/48f1a006b78944a944cdc0c98fb4b447e19fce7d.patch?full_index=1"
      sha256 "2fa14b78e00b455138324034f876979f40c34e253b5b254ea794e60a38ac657b"
    end

    # Backport support for LLVM 21
    patch do
      url "https://github.com/MaskRay/ccls/commit/44fb405d00dead04de43891c9818d798f10fc41e.patch?full_index=1"
      sha256 "40229b6bc013a6daf510b980a7b032bad159f43e95796467705042beeb70fe49"
    end
    patch do
      url "https://github.com/MaskRay/ccls/commit/4427527ed8107719457b5260443e8cad024e446f.patch?full_index=1"
      sha256 "16ba1cd3c18441054fcc54716e44e013ee01c21b25b796adc480620df511abe0"
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "bab741b9cdf3a65b32a9ded56977041854ea84233156e2a2cc6844d368c4fd46"
    sha256                               arm64_sequoia: "e9e2dfa3d50fed8794c77ca54c01ab922d40fed4d9e43b7374c1b9982fb1265f"
    sha256                               arm64_sonoma:  "9a6fb61ff9eee5a3122dfcccdc7d64b0fc63d720e79a4a7c5d60824c0acf7459"
    sha256                               arm64_ventura: "b12c07bff01f2db44152df2553711dd86848351f0f0d16b372289c90908cc592"
    sha256                               sonoma:        "b6d124927fb776640e9528947b6e52ec816e1f3ec7229dd2cbb647e274c32ab2"
    sha256                               ventura:       "20517554c04b283944ae28892e0b88139029873a45c45b19895bf4488d4878b0"
    sha256                               arm64_linux:   "773f2ac0a01f92f7473ddf0fd932d3b8be93efa1c39f261bb51a9cce64eccd40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f81e657e1923108992eb11bfe532fbc0e6753066924fd7906cc6b713b930e3a3"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
    resource_dir = Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp
    resource_dir.gsub! llvm.prefix.realpath, llvm.opt_prefix
    system "cmake", "-S", ".", "-B", "build", "-DCLANG_RESOURCE_DIR=#{resource_dir}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/ccls -index=#{testpath} 2>&1")

    resource_dir = output.match(/resource-dir=(\S+)/)[1]
    assert_path_exists "#{resource_dir}/include"
  end
end
