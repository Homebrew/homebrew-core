class Overturemaps < Formula
  include Language::Python::Virtualenv

  desc "Python tools for interacting with Overture Maps data"
  homepage "https://overturemaps.org"
  url "https://files.pythonhosted.org/packages/d0/65/8327d6961f9e5f526e899d1db376c277094c36f20f23d1a278b66e6939a6/overturemaps-1.0.0.tar.gz"
  sha256 "2fb9f5d37e2a215259cc1994ddcdf3f312f54f0491aee5457ce48aa9c0514240"
  license "MIT"
  head "https://github.com/OvertureMaps/overturemaps-py.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57cbfca0b12b56145860b6f4020795114cf2b3e0e8aac21e2dbec2b19eabcee3"
    sha256 cellar: :any,                 arm64_sequoia: "d8b5b0a550dcf69afa47623a107b5debeb0ecd88cfdcec24965b5bbfb90d154e"
    sha256 cellar: :any,                 arm64_sonoma:  "6ea77479bfdd3ea554154f594c99b3c713810d6417a71fd7c25883199b3f353a"
    sha256 cellar: :any,                 sonoma:        "3441070bbf564d8725fbd319e68c7bcd6b641d60de7cd6efbcc5aa160d7c6675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b98ba67163be82a39634d5ca51d9d1810071382d2b3b36050f3993e6bb9ac53c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c833ceb433e85de4162744b6da00b2f6cc69e9ae11a13c6e7cc2275f4994da02"
  end

  depends_on "cmake" => :build  # for pyarrow
  depends_on "ninja" => :build  # for pyarrow
  depends_on "rust" => :build   # for orjson
  depends_on "apache-arrow"
  depends_on "geos"             # for shapely
  depends_on "numpy"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages exclude_packages: "numpy"

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/9d/1b/2024d06792d0779f9dbc51531b61c24f76c75b9f4ce05e6f3377a1814cea/orjson-3.11.8.tar.gz"
    sha256 "96163d9cdc5a202703e9ad1b9ae757d5f0ca62f4fa0cc93d1f27b0e180cc404e"

    # Remove nightly feature flag, Rust 1.95 is now stable
    patch :DATA
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/91/13/13e1069b351bdc3881266e11147ffccf687505dbb0ea74036237f5d454a5/pyarrow-24.0.0.tar.gz"
    sha256 "85fe721a14dd823aca09127acbb06c3ca723efbd436c004f16bca601b04dcc83"
  end

  resource "pyfiglet" do
    url "https://files.pythonhosted.org/packages/c8/e3/0a86276ad2c383ce08d76110a8eec2fe22e7051c4b8ba3fa163a0b08c428/pyfiglet-1.0.4.tar.gz"
    sha256 "db9c9940ed1bf3048deff534ed52ff2dafbbc2cd7610b17bb5eca1df6d4278ef"
  end

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/4d/bc/0989043118a27cccb4e906a46b7565ce36ca7b57f5a18b78f4f1b0f72d9d/shapely-2.1.2.tar.gz"
    sha256 "2ed4ecb28320a433db18a5bf029986aa8afcfd740745e78847e330d5d94922a9"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  def python3
    "python3.14"
  end

  def install
    # The sdist has reproducible-build timestamps from 2020-02-02, which causes
    # Homebrew to set SOURCE_DATE_EPOCH to that date. This makes pip restrict
    # package downloads to pre-2020, breaking all modern build backends.
    # Reset to current time so the 24-hour safety window works as intended.
    ENV["SOURCE_DATE_EPOCH"] = Time.now.utc.to_i.to_s

    numpy_include = Formula["numpy"].opt_lib/Language::Python.site_packages(python3)/"numpy/_core/include"
    geos_include = Formula["geos"].opt_include
    geos_lib = Formula["geos"].opt_lib

    ENV.prepend "CFLAGS", "-I#{numpy_include} -I#{geos_include}"
    ENV.prepend "LDFLAGS", "-L#{geos_lib}"

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overturemaps --version")
    output = shell_output("#{bin}/overturemaps download 2>&1", 2)
    assert_match "Missing option", output
  end
end

__END__
--- a/src/lib.rs
+++ b/src/lib.rs
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: MPL-2.0
 // Copyright ijl (2018-2026)

-#![cfg_attr(feature = "cold_path", feature(cold_path))]
 #![cfg_attr(feature = "generic_simd", feature(portable_simd))]
 #![cfg_attr(feature = "optimize", feature(optimize_attribute))]
 #![allow(unused_features)] // portable_simd on universal2 cross-compile
