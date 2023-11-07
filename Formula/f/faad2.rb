class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faad2/archive/refs/tags/2.11.0.tar.gz"
  sha256 "720c1dc404439e0a9117aa144dc7ead56f1658adf4badbb39f959d6ad8eed489"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2ebed5aafcd31464d6c94c61ac0142faf278bfabf96cae166bdeccd8d90eacfa"
    sha256 cellar: :any,                 arm64_ventura:  "be936a4a08251f0d708e5a470d4af401a5b0f683dc0cb82fc428b29e9d3754ca"
    sha256 cellar: :any,                 arm64_monterey: "ed24e5dd89144695008089fc3f8de7031db3906cd64391e99eb67ba440056dad"
    sha256 cellar: :any,                 arm64_big_sur:  "90f7a0219e6f512686cb37c39c7436c3572d19822c5687dfe6244a4deea1bc4a"
    sha256 cellar: :any,                 sonoma:         "2a5c1c40284059b2b3f557bdc5965d7d339934671bd22badb929d4167ba6a4f9"
    sha256 cellar: :any,                 ventura:        "555671b7420b43ac310ff7a5a135bc122a66a848cd7c903b66afef51189506d6"
    sha256 cellar: :any,                 monterey:       "b749443a3607f7c18ac3dce49432d684f0446df8bc21173ab89b280bedaa5d7d"
    sha256 cellar: :any,                 big_sur:        "23ce45f3f6c3fc6959e0b09595e129411d8b45443888a1f1c272f5645805cca1"
    sha256 cellar: :any,                 catalina:       "9ff6536a2a0fa6b561750fa3d8886192de865edad71029e4ad68a27af18abe4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "300156e7a30d3e2b449f78f6671d1769f559a659241a55d9f074c8026193ab99"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/faad -h", 1)
    assert_match "infile.mp4", output
    assert_match version.to_s, output
  end
end
