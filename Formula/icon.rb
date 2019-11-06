class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://www2.cs.arizona.edu/icon/ftp/packages/unix/icon-v951src.tgz"
  version "9.5.1"
  sha256 "062a680862b1c10c21789c0c7c7687c970a720186918d5ed1f7aad9fdc6fa9b9"

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
