class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-5.1.0.tar.gz"
  sha256 "283beaa68e1eab41de080a58bb92349c8e47a2bb1b93d10f36ea30f418f1e338"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git"

  bottle do
    sha256 "e3b79b41df423b3574012ffa580e92b6b4e38d24bdfc652692af128e6cafb1ce" => :mojave
    sha256 "4f16d55d6180cf0f4dc8bb93c5c747919ff81ca73f49235c9a906020508ae44e" => :high_sierra
    sha256 "d03c80e77174389dc5c6983a7400810abcf07ecd8cdc88de546a185a9014c727" => :sierra
    sha256 "63ca34c2ed34998d779e906210e06f3f46c4becc9410c00985dfdecf0daf5f8f" => :el_capitan
  end

  depends_on "gnu-sed" => :build

  # Upstream could not fix OpenCL issue on Mavericks.
  # https://github.com/hashcat/hashcat/issues/366
  # https://github.com/Homebrew/homebrew-core/pull/4395
  depends_on :macos => :yosemite

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    cp_r pkgshare.children, testpath
    cp bin/"hashcat", testpath
    system testpath/"hashcat --benchmark -m 0"
  end
end
