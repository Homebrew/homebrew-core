class Jencrypt < Formula
  desc "File and directory encryption tool for automatically mounting data volumes"
  homepage "https://github.com/JamesZBL/jencrypt"
  url "https://github.com/JamesZBL/jencrypt/archive/v2.0.1.tar.gz"
  sha256 "fc7a3d0214147c07a59ec24978c1ca0d47438f54"
  license "Apache-2.0"

  def install
    bin.install "app.py" => "jencrypt"
  end

  test do
    system "true"
  end
end
