class Ccat < Formula
  desc "Like cat but displays content with syntax highlighting"
  homepage "https://github.com/jingweno/ccat"
  url "https://github.com/jingweno/ccat/archive/v1.1.0.tar.gz"
  sha256 "b02d2c8d573f5d73595657c7854c9019d3bd2d9e6361b66ce811937ffd2bfbe1"

  bottle do
    cellar :any_skip_relocation
    sha256 "aec38270a3b41a57fe6d05df08eea67042f2b65a2a5de30b2452afefd81a6d9d" => :catalina
    sha256 "0170dc610f0561cd562a2614f5bb0139cad5d37133a4181318a0edc08b3182c9" => :mojave
    sha256 "895c26dc74369ef72990fd79447e654f5266dda9c662d3bed2926caab7180678" => :high_sierra
    sha256 "aab86cfae41d1f4f9c93ad3a1680f21a5a0e9fad61190101582235174e4e214c" => :sierra
    sha256 "10eb7df98a05c968f006bbda2c6f690bd7d5053e4bb6d2c9c4a043616648a23b" => :el_capitan
    sha256 "063b4cab434b5d16e8884aad6eb7d18068c33f9ec884fabf5ada3ad821428897" => :yosemite
    sha256 "04342b5be5ffffaa696799b006b592cad530b0fcd510514ad9c72bc70c5865ba" => :mavericks
  end

  depends_on "go" => :build

  conflicts_with "ccrypt", :because => "both install `ccat` binaries"

  def install
    system "./script/build"
    bin.install "ccat"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      I am a colourful cat
    EOS

    assert_match(/I am a colourful cat/, shell_output("#{bin}/ccat test.txt"))
  end
end
