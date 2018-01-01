class Httpstat < Formula
  desc "Curl statistics made simple"
  homepage "https://github.com/reorx/httpstat"
  url "https://github.com/reorx/httpstat/archive/1.2.1.tar.gz"
  sha256 "b670f03d38ecaae40e05cae79dfc296b567598752d5fb6ec174836a5f4d0b381"

  bottle :unneeded

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    bin.install "httpstat.py" => "httpstat"
  end

  test do
    assert_match "HTTP", shell_output("#{bin}/httpstat https://github.com")
  end
end
