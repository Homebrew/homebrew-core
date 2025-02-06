class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-2.0.5.tar.gz"
  sha256 "f3c4d39921b2036aa77e1093cb21006bf8787f720a11a2a1ef9a80568d660bf3"
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
    sha256 cellar: :any,                 arm64_sequoia: "6a6cec6bf44edd06f6c1e28b495c0fa304f2830882b77500285c88668984a846"
    sha256 cellar: :any,                 arm64_sonoma:  "6f7d8145583412131ba6644d2d12b1527689092cb9acbb393cc5224a2a57ac37"
    sha256 cellar: :any,                 arm64_ventura: "62c5eda66395d6982793c0b78d760d457c935bc9caa3ec41f552b432e4284a87"
    sha256 cellar: :any,                 sonoma:        "da5981fc301df7030708641c60c80b8927f9620498225946ee5ae56f634e1c14"
    sha256 cellar: :any,                 ventura:       "f80b405938c2d6c997004e041f16a2a3b36c126df2322843b272a60124b35178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72869646ab902867515638c97b0c3e385b950403efe4f644581ba4b3100be9a6"
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

  def install
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
