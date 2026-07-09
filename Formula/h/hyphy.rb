class Hyphy < Formula
  desc "Hypothesis testing using Phylogenies"
  homepage "https://www.hyphy.org"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.101.tar.gz"
  sha256 "7eb3ff9c660e9a88b3e5f3ed8c553dc9ed6ab254259a9d00612d8347795c961f"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "9c2090b54e8021f1fa91639f95ef0c9d0b120c819db3ed73a89a977b363ce3db"
    sha256 arm64_sequoia: "695e75fa0363144ec45dc50afc8fb2cf59fa23c3b4873eeebcd372648e9a1250"
    sha256 arm64_sonoma:  "5a4c658273673d2db12c03312b6c94cc3f066fecf66d3a3aaba01704a75aaafa"
    sha256 sonoma:        "e0b20b65a50800eede00bfd6155575f375d2c447a3a6542aa1aa878cd7e4793a"
    sha256 arm64_linux:   "8f5256d366e9e42359b0d013dead4676f97672b920ee03abf378561ff9d1795b"
    sha256 x86_64_linux:  "4a711bdfbd1b2c591308c548a6694cd65eed3ccb9cad195e5053c860e498f16a"
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
