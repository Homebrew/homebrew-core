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
    sha256 cellar: :any,                 arm64_ventura:  "af12b9220a8b3b8c5bfe39b4ddb83c3cab630004f1af1da66566ea4d39f86097"
    sha256 cellar: :any,                 arm64_monterey: "fb0dbf1b74423633ba6401e9f5314eada89dcffa242af41e99d2907fac4ce1c9"
    sha256 cellar: :any,                 arm64_big_sur:  "f165c53b700b2be579cd7e20a329261db16c65bdc5539b1cbd126d14f8d6d960"
    sha256 cellar: :any,                 ventura:        "86b4cbdc8e0b8adf4fc6677cda90b03d99d9df1df9c687f9cb756ac08c7a9453"
    sha256 cellar: :any,                 monterey:       "846ba50072c4fc2d5134e8cbc4ec89a1d727e7a366f2540e89620ba2aef87bc9"
    sha256 cellar: :any,                 big_sur:        "89faba4d798577215568e3fe01b1f3753f44789cd565585962248434bde59a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc2f9611af7e631edd83a19197387e4aa193246d39cdbd74f79256b9a8d28d4"
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
