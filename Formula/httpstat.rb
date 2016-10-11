class Httpstat < Formula
  desc "Curl statistics made simple"
  homepage "https://github.com/reorx/httpstat"
  url "https://github.com/reorx/httpstat/archive/1.2.0.tar.gz"
  sha256 "a013fdee9a729f4641b48d14716000ca5aa3cb91f08ceda34c6bbf2c4885412c"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "httpstat.py" => "httpstat"
  end

  test do
    assert_match "HTTP", shell_output("#{bin}/httpstat https://github.com")
  end
end
