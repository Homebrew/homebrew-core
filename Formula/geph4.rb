class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.6.2.tar.gz"
  sha256 "2b96e3c5275905b3b06196cbaf4a17baed9901006d18d688385a2be72291126f"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5980c677ad6f2cddc85c4e5152fbc4fc67c932c707433fe31159f150e6ed8013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab2bfb4fcd537597be32f11779b649ab449a21e4716156b2569a1932710526ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f46f69c292e9340bb2535dbadc24968693dc550bea342e44e8c6d448c27ca498"
    sha256 cellar: :any_skip_relocation, ventura:        "acde10a40c14f62ac7ddf54a08c7d8de2377cabd533337fd99990877bea61739"
    sha256 cellar: :any_skip_relocation, monterey:       "2a0ab06630c89af252546b2f14d8f2154ef3df32ea8f1e354d1beb186ed06974"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee90e846681bdfa94f3e53b9376aa3e605a2a959113d64d741068371bb3c469a"
    sha256 cellar: :any_skip_relocation, catalina:       "05dcd75cf30db3bfa70c3ebf49105794f0aa1832529faabc9ad82a4fefaa9da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af784d417d32f0b73738b0cb655eb92dee36b12ae0ee03c251161ffb5e6b46c7"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
