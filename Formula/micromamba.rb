class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  stable do
    url "https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.4.5.tar.gz"
    sha256 "1aedf2ae4fb896af199d3af2acd6c7592957af15297bfcb619b7d13e09ce121a"

    # Fix "error: chosen constructor is explicit in copy-initialization".
    # Remove with `stable` block on next release.
    patch do
      url "https://github.com/mamba-org/mamba/commit/1547431efd48da79ce53cc486be00ca75c02ce01.patch?full_index=1"
      sha256 "1081cd4f431449979b6f89d2d930679ab371a4186b21b02d8834545867166c09"
    end
  end

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d6bf4b4d8c5e76bfc79e555c8c31d328997a0c260410357b0d0bb2ee9d9ae96f"
    sha256 cellar: :any,                 arm64_monterey: "0dbeb12eedebcb491bedb53a3365d2242a40d4feec9222822501241e135f767a"
    sha256 cellar: :any,                 arm64_big_sur:  "9ee9adf6d484d6fce52cb8fc6dec067e96878a0f011858030f9cb6883ad47314"
    sha256 cellar: :any,                 ventura:        "286cd6d8e18b78607811caec7af453bb7e3944b8d3dc620ab35d32511f07361c"
    sha256 cellar: :any,                 monterey:       "c57d9bbc0efa4d48462b703d0bcf6eb6822761ad3668cae4065d67ff3b06a2fb"
    sha256 cellar: :any,                 big_sur:        "f8c794a87c17fa5f32bc8480559cf6c2834ebdc575f4dbf6af58200631a1eb12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d117c46c501e3d48cbb15a9b103d90eb47ab41baa6f8b773f6885899ab30e2c"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build
  depends_on "fmt"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "reproc"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :monterey # uses CURLINFO_RETRY_AFTER, available since curl 7.66.0
  uses_from_macos "krb5"
  uses_from_macos "libarchive", since: :monterey
  uses_from_macos "zlib"

  resource "libarchive-headers" do
    on_monterey :or_newer do
      url "https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-113.tar.gz"
      sha256 "b422c37cc5f9ec876d927768745423ac3aae2d2a85686bc627b97e22d686930f"
    end
  end

  def install
    args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_SHARED=ON
      -DBUILD_MICROMAMBA=ON
      -DMICROMAMBA_LINKAGE=DYNAMIC
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    if OS.mac? && MacOS.version >= :monterey
      resource("libarchive-headers").stage do
        cd "libarchive/libarchive" do
          (buildpath/"homebrew/include").install "archive.h", "archive_entry.h"
        end
      end
      args << "-DLibArchive_INCLUDE_DIR=#{buildpath}/homebrew/include"
      ENV.append_to_cflags "-I#{buildpath}/homebrew/include"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Please run the following to setup your shell:
        #{opt_bin}/micromamba shell init -s <your-shell> -p ~/micromamba
      and restart your terminal.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micromamba --version").strip

    python_version = "3.9.13"
    system "#{bin}/micromamba", "create", "-n", "test", "python=#{python_version}", "-y", "-c", "conda-forge"
    assert_match "Python #{python_version}", shell_output("#{bin}/micromamba run -n test python --version").strip
  end
end
