class Conduit < Formula
  desc "Data Integration for Production Data Stores"
  homepage "https://conduit.io/"
  license "Apache 2.0"
  version "0.5.0"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/ConduitIO/conduit/releases/download/v0.5.0/conduit_.0.5.0_Darwin_x86_64.tar.gz"
    sha256 "548fee825360c816fe06c0b0c37ad3990ee7ff9e0bbfcaea12557d595276d662"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/ConduitIO/conduit/releases/download/v0.5.0/conduit_.0.5.0_Darwin_arm64.tar.gz"
    sha256 "4d52af5634e156d27df24ed1655b1474a68b519faa5836b8206313d56b0d3f77"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/ConduitIO/conduit/releases/download/v0.5.0/conduit_.0.5.0_Linux_x86_64.tar.gz"
    sha256 "505a006c38cb40b45d533adac7e9e19a0a530c5add1c599a1a0e68add7228535"
  end
  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://github.com/ConduitIO/conduit/releases/download/v0.5.0/conduit_.0.5.0_Linux_arm64.tar.gz"
    sha256 "1acbdf028cebda7bb569643e1d6f8f3313f570f51688137de16b88505e60a420"
  end

  head "https://github.com/ConduitIO/conduit.git"

  def install
    bin.install "conduit"
  end

  test do
    shell_output("#{bin}/conduit -version").match(/0.5.0/)
  end
end
