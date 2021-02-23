class Jencrypt < Formula
  desc "File and directory encryption tool for automatically mounting data volumes"
  homepage "https://github.com/JamesZBL/jencrypt"
  url "https://github.com/JamesZBL/jencrypt/archive/v2.0.1.tar.gz"
  sha256 "7c33062910afb2776317172ecfd3a162af1d6ac3bf564729040fb8ef5dd4b764"
  license "Apache-2.0"

  def install
    bin.install "app.py" => "jencrypt"
  end

  test do
    system "true"
  end
end
