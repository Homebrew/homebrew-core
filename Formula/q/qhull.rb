class Qhull < Formula
  desc "Computes convex hulls in n dimensions"
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2020-src-8.0.2.tgz"
  version "2020.2"
  sha256 "b5c2d7eb833278881b952c8a52d20179eab87766b00b865000469a45c1838b7e"
  license "Qhull"
  head "https://github.com/qhull/qhull.git", branch: "master"

  # It's necessary to match the version from the link text, as the filename
  # only contains the year (`2020`), not a full version like `2020.2`.
  livecheck do
    url "http://www.qhull.org/download/"
    regex(/href=.*?qhull[._-][^"' >]+?[._-]src[^>]*?\.t[^>]+?>[^<]*Qhull v?(\d+(?:\.\d+)*)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "e63077686c1ef66ea9f65e7e10d842aa788bdf21b6011dd3c0b2ccd35195ddb7"
    sha256 cellar: :any,                 arm64_sequoia:  "03294d7f8db8437cdf8d4d679ae41808a195b733907bf638671f99089592dc17"
    sha256 cellar: :any,                 arm64_sonoma:   "f2d64f8e284b65fd97bb19b8add86502b3b88c71e9338723aa38ac5a34361f91"
    sha256 cellar: :any,                 arm64_ventura:  "33bd3b7b6225c502fa1a21501cdd2ce72f92ab942bc9b5092f3c9172a2312f22"
    sha256 cellar: :any,                 arm64_monterey: "6d207280ccb3591c233825c16707691f2502b2e1d65d5e0c18fa66342cd8bea3"
    sha256 cellar: :any,                 arm64_big_sur:  "7aae401ecc2b918c1a860e6ead74141cbb0b58b2d797f5c5a214fb7ca088424d"
    sha256 cellar: :any,                 sonoma:         "4bc43edb0bba14a92203f6e4a31649db8d15a0fae8d71f7977d1e8189f1a597e"
    sha256 cellar: :any,                 ventura:        "8c5922f72dbf8061a0e6e0b459e6eca4898ee2236223965daae35fca77309b5c"
    sha256 cellar: :any,                 monterey:       "67ee6237ae95266f7acbb4e19ec2db41fd3fe22faa60060d9988e87cd473e073"
    sha256 cellar: :any,                 big_sur:        "dfd8138816f958dece1b6f30188ad3bfa53c3c8c74abf2ab22f3462477924b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "674616b881abea9139c0f2db580b813eecdc401e46842f792b19f843cff5eb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dc32a7258d2f678417041a1dbd2ea922369e67209062ada7b19caee4fd2c55c"
  end

  depends_on "cmake" => :build

  def install
    # Workaround for CMake 4.0+
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    odie "Remove cmake workaround" if build.stable? && version > "2020.2"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = shell_output("#{bin}/rbox c D2")
    output = pipe_output("#{bin}/qconvex s n 2>&1", input, 0)
    assert_match "Number of facets: 4", output
  end
end
