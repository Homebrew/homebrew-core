class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-5.1.0.tar.gz"
  sha256 "283beaa68e1eab41de080a58bb92349c8e47a2bb1b93d10f36ea30f418f1e338"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git"

  bottle do
    sha256 "b33b3b59b9e65fa33b35ade1cd7b39a334198701dd47ea89d3f717de1c3cdad5" => :mojave
    sha256 "3de92d3e2fbe15dcfeda31f900bd58fe92469f7e04d68b09a1e9db4e01d87781" => :high_sierra
    sha256 "383cf945f9263a4e777db23bcee81ab4175e4679930c657628b76d3430e8bd94" => :sierra
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
