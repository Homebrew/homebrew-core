class Atdtool < Formula
  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://github.com/lpenz/atdtool/archive/upstream/1.3.1.tar.gz"
  sha256 "eb634fd9e8a57d5d5e4d8d2ca0dd9692610aa952e28fdf24909fd678a8f39155"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac22c0d462774d7807e99dca779d47ab586afa210366a7be5568da76e378e4b9" => :high_sierra
    sha256 "ac22c0d462774d7807e99dca779d47ab586afa210366a7be5568da76e378e4b9" => :sierra
    sha256 "ac22c0d462774d7807e99dca779d47ab586afa210366a7be5568da76e378e4b9" => :el_capitan
  end

  depends_on "txt2tags" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/atdtool", "#{prefix}/AUTHORS"
  end
end
