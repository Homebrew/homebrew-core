class Jargon < Formula
  desc "Helps you import localizations from a Google Spreadsheet"
  homepage "https://github.com/dmiotti/jargon"
  url "https://raw.githubusercontent.com/dmiotti/jargon/master/releases/download/0.0.1/jargon.tar.gz"
  sha256 "900be186a0421d8e5dc47b413c7d56918c4663050a01b408afd3a536e565c436"

  def install
    bin.install "jargon"
  end

  test do
  end
end
