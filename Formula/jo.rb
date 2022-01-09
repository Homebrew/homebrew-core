class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"
  url "https://github.com/jpmens/jo/releases/download/1.6/jo-1.6.tar.gz"
  sha256 "eb15592f1ba6d5a77468a1438a20e3d21c3d63bb7d045fb3544f223340fcd1a1"
  license all_of: ["GPL-2.0-or-later", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43022572a3a5ff871de0e49654370793f67318322b215aa2488a5f22be1942a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd21640d777328ff0998078bd87a5eedb60aba137c3005736e649df581b5f836"
    sha256 cellar: :any_skip_relocation, monterey:       "0bcfda936f7f499a80c242fdaf75b4f2ecdd6d8731c69c1e9ffdab8e2704c2fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "690450d78ccd65827fe69b0720fec34bed108370f22dbc42c5e319c3e1c161b0"
    sha256 cellar: :any_skip_relocation, catalina:       "f0f91b17eff7454719e0a7b0572df7c5f5928eee844642d3685053181ff58e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54cb98b552b1405a27f6cb44ec7fac1690d3358b83405c696784431d1dd00fef"
  end

  head do
    url "https://github.com/jpmens/jo.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal %Q({"success":true,"result":"pass"}\n), pipe_output("#{bin}/jo success=true result=pass")
  end
end
