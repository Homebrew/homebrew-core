class CernNdiff < Formula
  desc "Numerical diff tool"
  # NOTE: ndiff is a sub-project of Mad-X at the moment.
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/refs/tags/5.09.03.tar.gz"
  sha256 "cd57f9451e3541a820814ad9ef72b6e01d09c6f3be56802fa2e95b1742db7797"
  license "GPL-3.0-only"
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e193003d9dc156d3c9f2740ace0ca73ce36299ef0de327abadf3d8a971235186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9d45e67a3d9f934e921d76dccfcbb31f4b1b3af041dac06b4505cdc4bae2fe73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89e85cfeaa7bb36ccf6c86e8e8cd1c969656c81ee54f73a4b544d47b4d9ef04d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9951fa4368100f6c4d2b600e7da2d15c3c1c4031e94666fa822f935502251afd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62a8a71d7515060897bea3dbe97136b0dac99454a403e370e859f482b4e129d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "807d3f5b977b2d2012901b5c9ed066ecd3ff4561a7758a03e503021a2e0594b2"
    sha256 cellar: :any_skip_relocation, ventura:        "141fb295ae4157e0b8f53d4ec91a465baa6380d8611652da5915f40298a50060"
    sha256 cellar: :any_skip_relocation, monterey:       "9ae23c61ad53062f561cc9a70e52a54d90add55b98962c06ea76e129359acc4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bcf2ffd38ba56b8c9c6c12a5da6be040a8fc0e73c338a46ddc47fa4d78e9df87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b79c1e4f9d23f8dd06659de060aa2fe4bf0b863a2f9d1e1da8cab2c3347c108b"
  end

  depends_on "cmake" => :build

  conflicts_with "ndiff", "nmap", because: "both install `ndiff` binaries"

  def install
    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", "tools/numdiff", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid installing MAD-X license as numdiff is under a different license
    rm "License.txt"
    prefix.install "tools/numdiff/LICENSE"
  end

  test do
    (testpath/"lhs.txt").write("0.0 2e-3 0.003")
    (testpath/"rhs.txt").write("1e-7 0.002 0.003")
    (testpath/"test.cfg").write("*   * abs=1e-6")

    system bin/"ndiff", "lhs.txt", "rhs.txt", "test.cfg"
  end
end
