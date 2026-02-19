class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://github.com/flann-lib/flann"
  url "https://github.com/flann-lib/flann/archive/refs/tags/1.9.2.tar.gz"
  sha256 "e26829bb0017f317d9cc45ab83ddcb8b16d75ada1ae07157006c1e7d601c8824"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6635599071926575a5e3eef3bd48521d93b5fb74da6e21fbf60d99c4b6823ff1"
    sha256 cellar: :any,                 arm64_sequoia: "ae73ea70a53e2f253d8c189d830b5607a6ec395cda17e418fcc5cca06d2ee4e4"
    sha256 cellar: :any,                 arm64_sonoma:  "e711080a6b6135afbc04dd206b201b9fb8ac1627b760d080eed9403ac361d6dc"
    sha256 cellar: :any,                 sonoma:        "9ac7f30cfe97912e5ea39b164fc24d1031af8db3cae79c357bcd6c3149325af4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "998d5a26830677da31aea0f6131483c3ac3922c1f2b4e7ba71641bd2902a641c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d5d3a9637124dff3e43fd033f0887a2520b63fe57a0605951cf888e87b7fb2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "hdf5"
  depends_on "lz4"

  def install
    args = %W[
      -DBUILD_PYTHON_BINDINGS=OFF
      -DBUILD_MATLAB_BINDINGS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-dataset" do
      url "https://github.com/flann-lib/flann/files/6518483/dataset.zip"
      sha256 "169442be3e9d8c862eb6ae4566306c31ff18406303d87b4d101f367bc5d17afa"
    end

    testpath.install resource("homebrew-dataset")

    system bin/"flann_example_c"
    system bin/"flann_example_cpp"
  end
end
