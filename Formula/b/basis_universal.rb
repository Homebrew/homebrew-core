class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/1.16.4.tar.gz"
  sha256 "e5740fd623a2f8472c9700b9447a8725a6f27d65b0b47c3e3926a60db41b8a64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f176e149c4baa2f3beaf3986ac77ecccbe1aa19d21bea15c10000ce74a67560"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f07b78dbb559ad8460d74beb4c7b1ddd4f4f2d3e2ad59bf240d6ce5b65119499"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60349947a86d4bd5b18563412ba991ef86c670ffc950a9a09a6eb6109e5da30d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d257f0ec38624ee12cd06276bf9027b8321f1164709740715767ee0f553a622e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cbd2ac330391e180fdb82185bdb2226636694634a1586f719fcba6efd3fb7a9"
    sha256 cellar: :any_skip_relocation, ventura:        "69185b9f65c1ef1e33048bdf4b9b326d1fa01541614c927ec5b596e69c5bf2f7"
    sha256 cellar: :any_skip_relocation, monterey:       "5edfa9db9c6aec95c25a11c3aed0737f5ce49da24ad3d0f5a239d279a5ac12e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "252c8b100e8897113762d5e6b666d393aa49f6ee94c9d52f90d4218c0c8ffdf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36381e52932ed44001c894b1d02abc0fec8b4412be8444eecfbb5b377cee807b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"basisu", test_fixtures("test.png")
    assert_predicate testpath/"test.basis", :exist?
  end
end
