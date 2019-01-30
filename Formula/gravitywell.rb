class Gravitywell < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://alexsjones.github.io/gravitywell"
  url "https://github.com/AlexsJones/gravitywell/releases/download/v0.1.6/gravitywell_0.1.6_Darwin_amd64.tar.gz"
  sha256 "6cdff10e5e8af0461f89d620101e53be1c568fa6bd0d41b71f5b51f8d6973d93"
  head "https://github.com/AlexsJones/gravitywell.git"

  def install
    bin.install "gravitywell"
  end

  test do
    `system "#{bin}/gravitywell", "-h"`
  end
end
