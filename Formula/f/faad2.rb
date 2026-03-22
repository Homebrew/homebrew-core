class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faad2/archive/refs/tags/2.11.2.tar.gz"
  sha256 "3fcbd305e4abd34768c62050e18ca0986f7d9c5eca343fb98275418013065c0e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b85c98bb399962a24b327bc0f361d4375169ee0490e2fa540e5958f65b7fe967"
    sha256 cellar: :any,                 arm64_sequoia: "8778a14f57fd5d09238b9f35247fa3150b5c9fcb80e38bb5d6f730cb5c1cfd82"
    sha256 cellar: :any,                 arm64_sonoma:  "2474465c5fda244f0841c983afb014b802332b04190ae10cb3a0c4ef00c18515"
    sha256 cellar: :any,                 arm64_ventura: "de416959deef6759acef50251453fc80ed2dc7cc59756e04014369b61d58ef53"
    sha256 cellar: :any,                 sonoma:        "c35f541928355a39a84f727c99f1ec98792c7a4ea60cf1e4e4f004a503ef19ce"
    sha256 cellar: :any,                 ventura:       "561f17f4430cb7808ab93cf94a65852f24f13186bb8dd5d3f5f6f920e5b63dd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e3d314b07dfa58ed8534ff0678217307d811ef4198f7e5abcbb46339757f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b83a27d69240eda9c177272cf3858a078d10240cd0d45783fda5836bcde86c6f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/faad -i #{test_fixtures("test.m4a")} 2>&1")
    assert_match "LC AAC\t0.192 secs, 2 ch, 8000 Hz", output
  end
end
