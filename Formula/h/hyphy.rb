class Hyphy < Formula
  desc "Hypothesis testing using Phylogenies"
  homepage "https://www.hyphy.org"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.100.tar.gz"
  sha256 "49ebc745907b37214da388341772e25df253244e02f3ab204bf0e27be84fcd8f"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "4f7152e4f93892e1dcefc885c4dcf2c75ed329e6ec0a15b25d7a3e519b06a99a"
    sha256 arm64_sequoia: "8193afec7d46ea5792a6417f10ffa9c2b6d10f848472edd240191e7117ae3760"
    sha256 arm64_sonoma:  "f4c64c700c6a12b379f37090297951f220fb0882f56f4f150370d05275acad83"
    sha256 sonoma:        "92eaa485bf64aa0e993d0eb2a1ef59ff446962dd9d6b19a1a915ccccb2e3ceff"
    sha256 arm64_linux:   "b3648ea224ef0248435ae1d487390a248a171f4f0f65812e364db56f0d9d0a59"
    sha256 x86_64_linux:  "b4e453867b9ec2013d217c871b88d32e916da5466378ff59672e84ab70525008"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hyphy --version")

    cp pkgshare/"data/p51.nex", testpath
    system bin/"hyphy", "slac", "--alignment", "p51.nex"
    assert_path_exists "p51.nex.SLAC.json"
  end
end
