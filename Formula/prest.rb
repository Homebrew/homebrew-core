class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/nuveo/prest"
  url "https://github.com/nuveo/prest/releases/download/v0.1.3/prest-darwin-10.6-amd64"
  sha256 "3635541e64f18dd7e3c40022f74d8ee94ed4f385dff73251e4c8f93dedc93fbc"

  bottle :unneeded

  def install
    mv "prest-darwin-10.6-amd64", "prest"
    bin.install "prest"
  end

  test do
    system "#{bin}/prest", "--help"
  end
end
