class Jencrypt < Formula
  desc "File and directory encryption tool for automatically mounting data volumes"
  homepage "https://github.com/JamesZBL/jencrypt"
  url "https://github.com/JamesZBL/jencrypt/archive/v2.0.1.tar.gz"
  sha256 "21e54443ad37a16d8fde208949e7e499a8221197fc3bfe46bb95b3be1c7249f7"
  license "Apache-2.0"

  def install
    bin.install "app.py" => "jencrypt"
  end

  test do
    system "true"
  end
end
