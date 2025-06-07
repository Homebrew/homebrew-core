class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/2.2.0.tar.gz"
  sha256 "b489d997bb288ada1c9988ed2fe2f8b6e49527487d9f1acf7cd4dd8e965bf32b"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9096bc7af168a8c500314ad3d6f95e4947f818dafa9f3f99dafe770edf07a03f"
    sha256 cellar: :any,                 arm64_sonoma:  "084d18b3a7909869444d6610d1f3fa002130255e159a5c6a6839e89b980486a0"
    sha256 cellar: :any,                 arm64_ventura: "35e2d122905ef62f16804a9b6d9644a8a6dcde8d2386dd7dd8f8adbd97b7ab95"
    sha256 cellar: :any,                 sonoma:        "38fd69a101dec25b7732a8144ced92b1ce5d01492048a6bf11fe2142811b73a4"
    sha256 cellar: :any,                 ventura:       "1a68ed6490da6b44bce6c856167cc6352e6a0407ba3715765cccf754c2eed515"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f8f9fd99152fa40e272ae2bcbd8a1c24dbfd7830bf0b385aecc780ec260c631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0649381189dc04f27fdb2f7a1e2dee5b233025d722e35cfe69fa2472a545a04a"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  # error: invalid operands to binary expression `<=>`
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build

  depends_on "fmt"
  depends_on "libarchive"
  depends_on "libsolv"
  depends_on "llvm" if OS.mac? && DevelopmentTools.clang_build_version <= 1500
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

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      ENV.llvm_clang
      ENV.append "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/c++ -L#{Formula["llvm"].opt_lib}/unwind -lunwind"
    end

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

    python_version = "3.9.13"
    system bin/"mamba", "create", "-n", "test", "python=#{python_version}", "-y", "-c", "conda-forge"
    assert_match "Python #{python_version}", shell_output("#{bin}/mamba run -n test python --version").strip
  end
end
