class Boilr < Formula
  desc "Boilerplate template manager that generates files from template repo"
  homepage "https://github.com/tmrts/boilr"
  url "https://github.com/tmrts/boilr/releases/download/0.3.0/boilr-0.3.0-darwin_amd64.tgz"
  version "0.3.0"
  sha256 "81c135073310adbfbfa1b46fabb8467c26e08053340491d604ee9bec886c18d8"

  def install
    bin.install "boilr"
  end

  test do
    system "#{bin}/boilr", "--help"
  end
end
