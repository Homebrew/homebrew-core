class Httpstat < Formula
  desc "Curl statistics made simple"
  homepage "https://github.com/reorx/httpstat"
  url "https://github.com/reorx/httpstat/archive/1.3.0.tar.gz"
  sha256 "8d529527d8a22419a99ce00895b5f7d95d035d2b2a8003d6bf661f875c797c31"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "httpstat.py" => "httpstat"
  end

  test do
    assert_match "HTTP", shell_output("#{bin}/httpstat https://github.com")
  end
end
