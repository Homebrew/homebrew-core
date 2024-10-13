class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faad2/archive/refs/tags/2.11.1.tar.gz"
  sha256 "72dbc0494de9ee38d240f670eccf2b10ef715fd0508c305532ca3def3225bb06"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2235c9a4c2e4dfe500c185e191f6a3487c0e18706a401b1fd403f2ad009dca8c"
    sha256 cellar: :any,                 arm64_sonoma:   "0130a83d47053aa23ad1687d1eac324f9bde6b1f22ab758e640bf3922c962bd5"
    sha256 cellar: :any,                 arm64_ventura:  "5f0fab6de9cf4dc35864e5ce8a7b8b5549dce4757da5f24d26bf7df058bbe628"
    sha256 cellar: :any,                 arm64_monterey: "8c1b8e4f6a5381a051289223200107587f040bbb76e4187785e59e0887d27d75"
    sha256 cellar: :any,                 sonoma:         "b4f4eeb17fc2aa94010f27a15996ab5a4e3285e6d9846b2ed436b20287c8d535"
    sha256 cellar: :any,                 ventura:        "d92da7073a8fe95e076caa978732cd56030a1904813fb3a277982512db347bc8"
    sha256 cellar: :any,                 monterey:       "c689f6e071a961e704f09722bc81d0c27aeccab1c155e322fdd44339b2894d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "680c21b82bfc3510ae708fda077f4e74dbb4662f6fd8250a5481f522f99f36da"
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
