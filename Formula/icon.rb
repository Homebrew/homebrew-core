class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://www.cs.arizona.edu/icon/ftp/packages/unix/icon-v951src.tgz"
  version "9.5.1"
  sha256 "062a680862b1c10c21789c0c7c7687c970a720186918d5ed1f7aad9fdc6fa9b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "824e189b6c174efa7e0f675c7bd4d90f19810f379d71b0195b508d2f6ec43986" => :mojave
    sha256 "7c2d0794956448b8bebf166c97a65aa23fde0847eeb7c6c9f8197eff2835ffb5" => :high_sierra
    sha256 "13d3963ef90d3f94f13a97e922185ea640233aee356e3bf8c2a0336de278482c" => :sierra
    sha256 "5218afb915b7892d4c242c659218735293136c3b100f54aa7199bcc716915939" => :el_capitan
    sha256 "44450b176b56db833a91ca6ae681e3876b2864a094b254340bcb5cd136957f17" => :yosemite
    sha256 "ca5ba233b4713e54680525ffd3ee7554988aa48f6a959f78b53c24e58d8c1c59" => :mavericks
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
