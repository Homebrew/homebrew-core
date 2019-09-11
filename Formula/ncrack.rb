class Ncrack < Formula
  desc "Network authentication cracking tool"
  homepage "https://nmap.org/ncrack/"
  url "https://github.com/nmap/ncrack/archive/0.7.tar.gz"
  sha256 "f3f971cd677c4a0c0668cb369002c581d305050b3b0411e18dd3cb9cc270d14a"
  head "https://github.com/nmap/ncrack.git"

  bottle do
    sha256 "b323c29b588f397487e74ee9e7312a8344a4b4c728043cf825838a0e19c58c17" => :mojave
    sha256 "297c3ca427025e5e07a435e8c46f96846c10c88a3a19eaf432639d05c1e82d12" => :high_sierra
    sha256 "5f1be0ae0ed5b38dc19ff32b4b157b81929bbfa2e8ebf524f0406a5dca962fc2" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_f.to_s, shell_output(bin/"ncrack --version")
  end
end
