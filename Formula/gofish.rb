class Gofish < Formula
  desc "Cross-platform systems package manager"
  homepage "https://gofi.sh"
  url "https://github.com/fishworks/gofish.git",
      :tag      => "v0.12.2",
      :revision => "7ffd9b5ecf427284c425eb86830a53e427eda5f9"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bac35a400b653cf733b089e18eff0b99695c99d08f5dd1a0e199328b360de376" => :catalina
    sha256 "8c9b0f7f5ba7d628cb52aa0b1ab01d1712fd206dce43ad5ac91296b8a3c51ca8" => :mojave
    sha256 "60a95d0ee72b99643765e8f1f29d4551007d904f644a447df2ee1c8706c1b072" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gofish"
  end

  def caveats
    <<~EOS
      To activate gofish, run:
        gofish init
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/gofish version")
  end
end
