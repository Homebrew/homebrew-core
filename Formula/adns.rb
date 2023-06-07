class Adns < Formula
  desc "C/C++ resolver library and DNS resolver utilities"
  homepage "https://www.chiark.greenend.org.uk/~ian/adns/"
  url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.6.0.tar.gz"
  sha256 "fb427265a981e033d1548f2b117cc021073dc8be2eaf2c45fd64ab7b00ed20de"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]
  head "https://www.chiark.greenend.org.uk/ucgi/~ianmdlvl/githttp/adns.git", branch: "master"

  livecheck do
    url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/"
    regex(/href=.*?adns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39fa25cc2f79cc7187c9ef2c5bcd40e4f02a143ac64ae8c6d1d14758235def1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a84000c6ecb31175af08ba967851c7c82b7a69e0fdc54a9564ce4bc3f48c893b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c5f65f0165f568dd85bb04b472b4a6dbd8e37a63f6fa895090fec4f85ac7796"
    sha256 cellar: :any_skip_relocation, ventura:        "6a4c2921b3b5cd87806e3e79bb408e51aa92e9ec0d06c7bff7e80819ea1dd199"
    sha256 cellar: :any_skip_relocation, monterey:       "79d82c25d06b3d8995fe1b5a781673793509c09050fd964a1e63089b229afd82"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c04df018648aa59b85137f9225399ac2f934b5ac20f3f91746efe433ff06f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da80477f679b94314466b05ac46083ef6db5d75dc98616159491ea265b626c9a"
  end

  uses_from_macos "m4" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dynamic"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/adnsheloex", "--version"
  end
end
