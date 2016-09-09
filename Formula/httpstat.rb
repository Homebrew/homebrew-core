class Httpstat < Formula
  desc "Curl statistics made simple"
  homepage "https://github.com/reorx/httpstat"
  url "https://github.com/reorx/httpstat/archive/v1.1.2.tar.gz"
  sha256 "0468abebfbae9ff7ea35d577b60ff9af9db3ff67ffd81b11ac005c4e9602919b"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "httpstat.py" => "httpstat"
  end

  test do
    assert_match "HTTP", shell_output("#{bin}/httpstat https://github.com")
  end
end
