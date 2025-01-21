class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-2.0.5.tar.gz"
  sha256 "f3c4d39921b2036aa77e1093cb21006bf8787f720a11a2a1ef9a80568d660bf3"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "98e6925fbd830cc6d97519d156ad96b9cbf084c105e69e6011552c9350269919"
    sha256 cellar: :any,                 arm64_sonoma:  "fa02f1e214165e3d129d748a381eece8d8e3dc54e170b69f1dfc70caa30924c5"
    sha256 cellar: :any,                 arm64_ventura: "d40632ab7e49c6c0507b219805638062a3beab449ccea7206686f3f6c1f63a9c"
    sha256 cellar: :any,                 sonoma:        "90c2f3094ea6f654fd6fb861e8f37e3be10cef230dd753c096259e16c8327baf"
    sha256 cellar: :any,                 ventura:       "fbf91b7946c5f582c35738ad659f7cd94c9f51df8597ec4e9bd43dd055c7a06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7effa46da6d8528914ecd827b2271fc40fee8d67c9aa93c3cc9e110981e3781"
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
