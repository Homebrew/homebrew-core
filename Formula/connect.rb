class Connect < Formula
  desc "Provides SOCKS and HTTPS proxy support to SSH"
  homepage "https://github.com/gotoh/ssh-connect"
  url "https://github.com/gotoh/ssh-connect/archive/1.105.tar.gz"
  sha256 "96c50fefe7ecf015cf64ba6cec9e421ffd3b18fef809f59961ef9229df528f3e"
  license "GPL-2.0-or-later"
  head "https://github.com/gotoh/ssh-connect.git"

  livecheck do
    url :head
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "90d0c91146180552a3a023ceba3850804139eb30b146151efe9c6d889ab9c99d" => :big_sur
    sha256 "33e6c06bbe902eea4790679f99c9aef340cce1e647238a13c151300afa46ee1a" => :arm64_big_sur
    sha256 "a08dfce847d75746d2b31ed3561e961fdcf950b051c5860e6d137ff5e1bcd1c7" => :catalina
    sha256 "cc0a39f7e2fea7672f6d691d2e1221d0c5963a9f7e0039317930418fc7c7ebfa" => :mojave
  end

  def install
    system "make"
    bin.install "connect"
  end

  test do
    system bin/"connect"
  end
end
