class Adns < Formula
  desc "C/C++ resolver library and DNS resolver utilities"
  homepage "https://www.chiark.greenend.org.uk/~ian/adns/"
  url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.6.1.tar.gz"
  sha256 "7138b3789b7506bd683f451d4f7d853077a91803b7b35d86ec667f0f9cd401cd"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]
  head "https://www.chiark.greenend.org.uk/ucgi/~ianmdlvl/githttp/adns.git", branch: "master"

  livecheck do
    url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/"
    regex(/href=.*?adns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "13b27a569da82d1c3dccfbd733715ca0e4b850462ee7cd74561b3753945848be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c3d3ebb294a2b86724d9484f996261c4e76472c8519618662300d4023d75a6b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a18386d620c3bdb3136f4800b3f972d545ddd63753363d4425d3d4e819c4474"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72889b372cd9dbba605289c703e885a518d2f4d34aed5f1103bd2af0b3d471aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1143604507ce762772b0ed61e367827054e1414ea1a24883fbe8b8d8dc026aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "fefe889ad072b0186eb26a445a13bff68e1f1e0914fce32273be408449c6518e"
    sha256 cellar: :any_skip_relocation, ventura:        "903ec0367e65867e0c69b536c535c24de0e588ceac6b2b53b6a0880194ce3e52"
    sha256 cellar: :any_skip_relocation, monterey:       "7f461bac71655ec0e4c05041dcd456e2648b2a1960ea8a633198ae35f1ba5557"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "61536298beb99ff2010ca729c20656b74b9ce355d246bb5df0e2b187b01501ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ac86275f06493e6589ea7f3c6306281891074deb2d4b3318652ee5e3d66d594"
  end

  uses_from_macos "m4" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dynamic"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"adnsheloex", "--version"
  end
end
