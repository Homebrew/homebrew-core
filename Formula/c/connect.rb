class Connect < Formula
  desc "Provides SOCKS and HTTPS proxy support to SSH"
  homepage "https://github.com/gotoh/ssh-connect"
  url "https://github.com/gotoh/ssh-connect/archive/refs/tags/1.106.tar.gz"
  sha256 "4f07eec36e6da2c4641a9ea9a2fd0617d6fc6aff5b65b6433f8a6447bea8a002"
  license "GPL-2.0-or-later"
  head "https://github.com/gotoh/ssh-connect.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7963a8e035492268bdaa843a6d79a88728f98abca2115bd50194384b5ae4cb0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22a3bbe8d775409efdddb1fdaa3bc59267524ac329cd061f93212de9fd4c75e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d1bc5a082a99f279f21adb0f8b7028e57f78f99b366cd77a5e008dd4b246edb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea352ab877ca1ad7156dcb9b3f90fba25d02cb286c8254dc25dfb4b1baa25d0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd13498f3a1e78e2269d207290950942aebc3216e9de777e32609756870de7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "157c7c54b61c285ee545c97a5c74e975cc44741c6cc845c82d0ae186cbc04a3a"
  end

  def install
    system "make"
    bin.install "connect"
  end

  test do
    system bin/"connect"
  end
end
