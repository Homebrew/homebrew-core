class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/2.10.0.tar.gz"
  sha256 "396cf6c08f16ecbc0a98b45a3f14469911aa2f6dda9c3b4ca98d010cea017835"
  license "BSD-3-Clause"
  revision 4
  compatibility_version 1
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    manifest_sha256 "25482cd7d2f1ccce4266380d6b2a1b62011e04e4a4a649c0367398403930be4a"
    sha256 cellar: :any, arm64_golden_gate: "54d3803d19a430b77df81b1bcf4195206ef87c0aed937511cb0374b32f81da46"
    sha256 cellar: :any, arm64_tahoe:       "d241b44ca72635a4574e8e8110a81ea72cd82ebb23b573a91ae11c7572198b18"
    sha256 cellar: :any, arm64_sequoia:     "57892014ff6a3ea6078c792a62d26537210e76a85889a0d0a76e72096568fc65"
    sha256 cellar: :any, arm64_linux:       "3081d44574f22df370532c7f8d66863a552a20976bbab4ca3d1c0c943c2941bc"
    sha256 cellar: :any, x86_64_linux:      "b1aeb51af9921cafd7ed5b16c785c484ec1abe79a0c959e6983710bfe1770d7b"
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
  depends_on "msgpack"
  depends_on "openssl@4"
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
    depends_on "howard-hinnant-date"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1600
    cause "Requires C++23 support for `std::ranges::views::join`"
  end

  fails_with :gcc do
    version "13"
    cause "Requires C++20 `std::chrono::parse`"
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
