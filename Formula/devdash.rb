class Devdash < Formula
  desc "Highly Configurable Terminal Dashboard for Developers"
  homepage "https://thedevdash.com"
  url "https://github.com/Phantas0s/devdash/archive/v0.2.0.tar.gz"
  sha256 "11760bb308680bcbfb138dd57df4a6b4b069ce082cf9e53275028bd23ea23b78"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/devdash", "./cmd/devdash"
  end

  test do
    system bin/"devdash", "-term"
  end
end
