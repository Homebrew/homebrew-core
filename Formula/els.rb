class Els < Formula
  desc "Displays emoji icons alongside ls output."
  homepage "https://github.com/AnthonyDiGirolamo/els"
  url "https://raw.githubusercontent.com/AnthonyDiGirolamo/els/master/els"
  version "1.0"
  sha256 "93ca8e9f2906cb03ff452f7c4819744983371f7a5a3366d4689fa0fc45906b7e"
  depends_on :ruby => "1.9"

  def install
    bin.install "els"
  end

  test do
    system "#{bin}/els"
  end
end
