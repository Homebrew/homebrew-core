class Connect < Formula
  desc "Provides SOCKS and HTTPS proxy support to SSH"
  homepage "https://github.com/gotoh/ssh-connect"
  url "https://github.com/gotoh/ssh-connect/archive/1.105.tar.gz"
  sha256 "96c50fefe7ecf015cf64ba6cec9e421ffd3b18fef809f59961ef9229df528f3e"
  license "GPL-2.0-or-later"
  head "https://github.com/gotoh/ssh-connect.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e45ad845a768453d0d0dc278dc9fb39f3a7601f33b79d8c1b5d8e404f1dc3377"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33e6c06bbe902eea4790679f99c9aef340cce1e647238a13c151300afa46ee1a"
    sha256 cellar: :any_skip_relocation, monterey:       "087274a2b2cd22db73d094b35dbb04389fabe7ce7b3d5d68a18a877bdbf50ac1"
    sha256 cellar: :any_skip_relocation, big_sur:        "90d0c91146180552a3a023ceba3850804139eb30b146151efe9c6d889ab9c99d"
    sha256 cellar: :any_skip_relocation, catalina:       "a08dfce847d75746d2b31ed3561e961fdcf950b051c5860e6d137ff5e1bcd1c7"
    sha256 cellar: :any_skip_relocation, mojave:         "cc0a39f7e2fea7672f6d691d2e1221d0c5963a9f7e0039317930418fc7c7ebfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ef58829a226ee7573f34e1b8a6282a7f26dfb8d730700eeff992f65a8f84ac"
  end

  def install
    system "make"
    bin.install "connect"
  end

  test do
    system bin/"connect"
  end
end
