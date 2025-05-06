class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://github.com/mamba-org/mamba/archive/refs/tags/2.1.1.tar.gz"
  sha256 "789d3d89fe8ca9f06344da21797e3d949ad1ff0ae4c633dc242a333e0ee37485"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74d15240890ade0f18fc3177f478b15637cd472afa8b07394c658cf318719e51"
    sha256 cellar: :any,                 arm64_sonoma:  "928e0f64d19adf80b818f62bd1fd62bbeecf751b7c8aaf2ed3cad596f22feb4c"
    sha256 cellar: :any,                 arm64_ventura: "afdc521ae40b2719038bb2f823dd2aeae29f2228f3dd3cc52222dba2f44740b6"
    sha256 cellar: :any,                 sonoma:        "a04b81ba206040796ad0bea5aa1a86271b4223e5b56d2c2e7fa7b26e9f7e81f7"
    sha256 cellar: :any,                 ventura:       "58cb2cf31fddd3bd268c6d7a129beddf92c475d3d10e8dd11ddfbdf05c8b5c55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bdda7e4d68b3a7956c17afba45ede0f90c80ad5a406258a815fa216fac1150f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f22521844f3e9957a8be3a860443643ee5a38220163c20b496f083404fe020ce"
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
