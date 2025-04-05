class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1102_SDK.zip"
  version "11.02"
  sha256 "2c4cf34792ec4339de290f17c1cc0a9c663fed58728db767b5c87fc9e5266338"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "578d3d0a7968057c86d572cfcf29a76819899de23e9a9ab0abdaafd37f81a214"
    sha256 cellar: :any,                 arm64_sonoma:  "0dcbb8881af07a7b8fffe8c11eea741eec5775a010ecccd3b825ad61740c98a3"
    sha256 cellar: :any,                 arm64_ventura: "db0479855c6cdb25ad011997b36e081496f7c336664e91d83d63b4bac7a5fdc2"
    sha256 cellar: :any,                 sonoma:        "3e718d7aacc7d15046aa7fdd95e651a3119ccd5489325123ac07079a026ce7cf"
    sha256 cellar: :any,                 ventura:       "4faf7f64d4a7d532ff27e349f06cf89f19329a17bb98dec19ca9f4bac29705f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba43955138dcd4bc32b8e7ad4a9ffb62c86918145288e1b5b10db2c15fc56211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d22279e7212b6ee3b924609b33a8a7092bf2ffaf8d654c814c9197909e90ca7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mac", test_fixtures("test.wav"), "test.ape", "-c2000"
    system bin/"mac", "test.ape", "-V"
    system bin/"mac", "test.ape", "test.wav", "-d"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.wav").read),
                 Digest::SHA256.hexdigest((testpath/"test.wav").read)
  end
end
