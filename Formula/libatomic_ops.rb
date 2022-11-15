class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.14/libatomic_ops-7.6.14.tar.gz"
  sha256 "390f244d424714735b7050d056567615b3b8f29008a663c262fb548f1802d292"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "923123069423e6c3042795d894a96d90717891bf12d9ba938c4c6e835edbad4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2c524cf7b2a2066d9629190b75039283ca008f5a74752cca3b3c7387bed94a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6eb5d6a03178df1b704517496c79ddc4ceda06ec3d80e5c1230bd938232e629"
    sha256 cellar: :any_skip_relocation, ventura:        "fea7c9063ec293adb2096598983c66376cdc14de7b7ca8d21648b51cd411cdfe"
    sha256 cellar: :any_skip_relocation, monterey:       "a2e24f4fb5d734c6407a87e6d92aad0fa8a6fae7d18c22794661b1f93a6484d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b41940cd48c41a9cb04a2ad951430240508c6153c51e97e237091d5618c8f04"
    sha256 cellar: :any_skip_relocation, catalina:       "cfb78b72dd3fcccea0bb983380505c5b21b55811a9aa81c34996154ce59108b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67609f40170efe9725285e1fa97ae6042acf52eeded974f6e085db707decebd8"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
