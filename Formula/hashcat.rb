class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  # MacOS curl complains about https://hashcat.net SSL cert
  # See https://github.com/Homebrew/homebrew-core/pull/56503#issuecomment-660728358
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.0.0.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/v6.0.0.tar.gz"
  sha256 "e8e70f2a5a608a4e224ccf847ad2b8e4d68286900296afe00eb514d8c9ec1285"
  license "MIT"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git"

  bottle do
    sha256 "4ad387b50b7aeb56058d3e83fbac70d6f750d4636d255f94534526d9d6885b56" => :catalina
    sha256 "b33b3b59b9e65fa33b35ade1cd7b39a334198701dd47ea89d3f717de1c3cdad5" => :mojave
    sha256 "3de92d3e2fbe15dcfeda31f900bd58fe92469f7e04d68b09a1e9db4e01d87781" => :high_sierra
    sha256 "383cf945f9263a4e777db23bcee81ab4175e4679930c657628b76d3430e8bd94" => :sierra
  end

  depends_on "gnu-sed" => :build

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
