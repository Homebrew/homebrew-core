class Afsctool < Formula
  desc "Utility for manipulating APFS and ZFS compressed files"
  homepage "https://brkirch.wordpress.com/afsctool/"
  url "https://github.com/RJVB/afsctool/archive/refs/tags/1.7.2.tar.gz"
  sha256 "a0d01953e36a333c29369a126a81b905b70a5603533caeebc2f04bbd3aa1b0df"
  license all_of: ["GPL-3.0-only", "BSL-1.0"]
  head "https://github.com/RJVB/afsctool.git"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01af9a80d59e870a48adcbf1eb0cba0a3dd0a4013df397114c4c0f21f16e3916"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7d401a4f723f58ad588e5b2fb5b19c6d76e7faed0385d0b3eef59d1f933e1ee"
    sha256 cellar: :any_skip_relocation, catalina:      "f418e15be4bafdcb1a85e14c3148c8d4af1b300bd6ed3e4a30eca3725459ac48"
    sha256 cellar: :any_skip_relocation, mojave:        "15c264a828ed98a42cc5ac68869c16b8306f73effe108e50bb1f731574311c51"
    sha256 cellar: :any_skip_relocation, high_sierra:   "72e92414d524b82ec1d8381ad50f55bd330f1109a5e10bca4235300fee557caf"
    sha256 cellar: :any_skip_relocation, sierra:        "96437b04a2974c215979550d3d70b4c8e3f609e76954ca41059c6f246da452ee"
  end

  depends_on "cmake" => :build
  depends_on "google-sparsehash" => :build
  depends_on "pkg-config" => :build
  depends_on :macos

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    bin.install "afsctool"
    bin.install "zfsctool"
  end

  test do
    path = testpath/"foo"
    path.write "some text here."
    system "#{bin}/afsctool", "-c", path
    system "#{bin}/afsctool", "-v", path

    system "#{bin}/zfsctool", "-c", path
    system "#{bin}/zfsctool", "-v", path
  end
end
