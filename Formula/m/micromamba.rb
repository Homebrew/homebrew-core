class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/2.3.3.tar.gz"
  sha256 "4f1aaf3aa5098037c3fc1571feaa2d8f256829baafd6d5b4556624791e5c0217"
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
    sha256 cellar: :any,                 arm64_tahoe:   "1a394062b5187c7fd2e1f888df36b57fe77b6c4715e38d5b091a3c43dc26cdec"
    sha256 cellar: :any,                 arm64_sequoia: "49e9e3d4f5cd4684e199946469954e2aa94abb8a7e58f912311c8a6b3e27a534"
    sha256 cellar: :any,                 arm64_sonoma:  "61976cfad1d74e89dfcda26e47e269b5ad8909e477765793f73a836f33edf169"
    sha256 cellar: :any,                 sonoma:        "bbbfc9843b431b862d4227265fc292f50d23a8ca4e275400e125b61b3c6bf819"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66370e659f889039a5b78c93dae4d4e5735792eb3cdf0554f02e369982b102ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1b90f7e8082b837629e4d6adc58552bc6a30667545d3ffdd7d0d61cad7ad99"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
    cause "Requires C++23 support for `std::ranges::views::join`"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1600

    args = %W[
      -DBUILD_LIBMAMBA=ON
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
