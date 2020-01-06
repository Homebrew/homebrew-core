class Dtool < Formula
  desc "Command-line tool collection to assist development"
  homepage "https://github.com/guoxbin/dtool"
  url "https://github.com/guoxbin/dtool/releases/download/v0.4.0/dtool-mac.tar.gz"
  version "0.4.0"
  sha256 "98ee2948fa959cf53700873a1e8fc5473a72fb3d9dec41725f42bd3a8803e0e2"

  def install
    bin.install "dtool"
  end

  test do
    assert_match "0x61626364", shell_output("#{bin}/dtool s2h abcd")
  end
end
