class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/2.5.0.tar.gz"
  sha256 "2d8761e423275b2e2b46352c99bdedc062ca22b98871ffa82e044d2be74b350f"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8678ce8b38fc758ec3bfff83ffad875001df11d6e55d090e0f672f90490a5a1"
    sha256 cellar: :any,                 arm64_sequoia: "f8b325e926d55ed25607a859ba6ef247683637b75ac744d5731a5bb0fb55c74f"
    sha256 cellar: :any,                 arm64_sonoma:  "07f65fd67e88363f8d9dc25a5a74744988a660289d7cc1ded0fe30d4136080ee"
    sha256 cellar: :any,                 sonoma:        "900809d133149d98b61debf4ac3a49ee414dd9e2cd4db00da8f369e8131451bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f687b8ab4d038348551d4b242b4f1e23321521bbbbdf834231527b980f0ae7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6abbd4c8170649cb65a7bb994ba5aac96fe193d08986e3992b5aadea00cf3962"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build

  depends_on "fmt"
  depends_on "libarchive"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "reproc"
  depends_on "simdjson"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl", since: :ventura # uses curl_url_strerror, available since curl 7.80.0
  uses_from_macos "krb5"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1600
    cause "Requires C++23 support for `std::ranges::views::join`"
  end

  def install
    args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_LIBMAMBA_SPDLOG=ON
      -DBUILD_SHARED=ON
      -DBUILD_STATIC=OFF
      -DBUILD_MAMBA=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # Upstream chooses names based on static or dynamic linking,
    # but as of 2.0 they provide identical interfaces.
    bin.install_symlink "mamba" => "micromamba"
  end

  def caveats
    <<~EOS
      Please run the following to setup your shell:
        #{opt_bin}/mamba shell init --shell <your-shell> --root-prefix ~/mamba
      and restart your terminal.
    EOS
  end

  test do
    ENV["MAMBA_ROOT_PREFIX"] = testpath.to_s

    assert_match version.to_s, shell_output("#{bin}/mamba --version").strip
    assert_match version.to_s, shell_output("#{bin}/micromamba --version").strip

    # Using 'xtensor' (header-only package) to avoid "broken pipe" codesigning issue
    # encountered on macOS 13-arm and 14-arm during CI.
    system bin/"mamba", "create", "-n", "test", "xtensor", "-y", "-c", "conda-forge"
    assert_path_exists testpath/"envs/test/include/xtensor.hpp"
  end
end
