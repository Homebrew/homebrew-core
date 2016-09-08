class Httpstat < Formula
  desc "curl statistics made simple"
  homepage "https://github.com/reorx/httpstat"
  url "https://github.com/reorx/httpstat/archive/v1.1.2.tar.gz"
  sha256 "0468abebfbae9ff7ea35d577b60ff9af9db3ff67ffd81b11ac005c4e9602919b"

  bottle :unneeded

  def install
    bin.install "httpstat.py"
    mv bin/"httpstat.py", bin/"httpstat"
  end

  test do
    system "#{bin}/httpstat", "https://github.com"
  end
end
