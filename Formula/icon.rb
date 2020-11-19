class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/v9.5.20i.tar.gz"
  sha256 "3ebfcc89f3f3f7acc5afe61402f6b3b168b8cd83f79021c98bbd791e92c4cbe8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a4f708b77cf3147ad2bc029577a7f56aa4cd2a4d192e9fc0a28eb34dcc08775f" => :catalina
    sha256 "3b97859fb6ac03f3420628fef5d660fbbf6208f642a979307b6bc85e063eb5c3" => :mojave
    sha256 "f0f50c06a2355371e01ea83f95a1743d94815f3029c0d74ce5888f446c07ab18" => :high_sierra
  end

  def install
    ENV.deparallelize
    system "make", "Configure", "name=posix"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    args = "'procedure main(); writes(\"Hello, World!\"); end'"
    output = shell_output("#{bin}/icon -P #{args}")
    assert_equal "Hello, World!", output
  end
end
