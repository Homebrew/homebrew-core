class Adns < Formula
  desc "C/C++ resolver library and DNS resolver utilities"
  homepage "https://www.chiark.greenend.org.uk/~ian/adns/"
  url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.6.2.tar.gz"
  sha256 "d0f62b6028bba2676a1e8f863181d92b2155104a3e73418ae94c316695853fc9"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]
  head "https://www.chiark.greenend.org.uk/ucgi/~ianmdlvl/githttp/adns.git", branch: "master"

  livecheck do
    url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/"
    regex(/href=.*?adns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "476b8d52436281919b2d7c58842d10639c2b7b1b36040d9e92880c779efafcb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce908b2bbf29716b8cbf5b720f60bcc9cc4fc9ec8a211fe7883c042529538785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40b39178f471c2ff5a3f42832d0333841fbc36eb1effc0325686a5089903fb0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f98a269f36fb69622b6a8739766ff6c8ac5c2baec826203a93a4d58ce1ff2788"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d983ba100a6cb146c0aa23ecc55c80d8b06aa5876979f40961faaae4662d83c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41d5aeafb129564e9f91c794235a9d256abb0b8b4dc8ee52d55f7241700e2a03"
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
