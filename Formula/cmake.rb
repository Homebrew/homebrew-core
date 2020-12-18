class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.19.2/cmake-3.19.2.tar.gz"
  sha256 "e3e0fd3b23b7fb13e1a856581078e0776ffa2df4e9d3164039c36d3315e0c7f0"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  livecheck do
    url "https://cmake.org/download/"
    regex(/Latest Release \(v?(\d+(?:\.\d+)+)\)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ea7e85abbc6e45d10b1f4b7f9d61cc1888c72e414140f71de1570f5522294501" => :big_sur
    sha256 "9cf0ad192e48828f2cb9d8a8d6d68f5282f76dc9959ce8b65c88ce078b8bbea1" => :arm64_big_sur
    sha256 "f1ac09ad5cd3634224b1bde4e8b55856fc0e911227597d9768c07bcd29fd9860" => :catalina
    sha256 "d301ad06bf88e6aa9354298ae92c22e051ac2f0b3ab0c3eba3004f6c673a749a" => :mojave
  end

  depends_on "sphinx-doc" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
      --system-zlib
      --system-bzip2
      --system-curl
    ]

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
