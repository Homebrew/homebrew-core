class Fly < Formula
  desc "Concourse fly cli"
  homepage "https://concourse.ci"
  url "https://github.com/concourse/concourse/releases/download/v2.3.1/fly_darwin_amd64"
  sha256 "4940c41cddc94887a2a838e3c4259e5d6ff4448550d2a680621518c14a648039"

  def install
    bin.install "fly_darwin_amd64" => "fly"
  end

  test do
    system "#{bin}/fly", "help"
  end
end
