class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"
  url "https://github.com/jpmens/jo/releases/download/1.6/jo-1.6.tar.gz"
  sha256 "eb15592f1ba6d5a77468a1438a20e3d21c3d63bb7d045fb3544f223340fcd1a1"
  license all_of: ["GPL-2.0-or-later", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee1505a91b7311ab4df7b1ef03c0d86390eede2ae654654afd8447c4f6f83f5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3347176b77aed759f5216aca83092020d3d7509dd38abb24483bf2ecae2b293f"
    sha256 cellar: :any_skip_relocation, monterey:       "0683bc5162ed66717cc09a5d0ebb822334dc165daf71ef5dde7a9fda7f9940d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "23a93bcbe720a84429bd69cf4e350a44a3664cb725458c3aa28eb305869c1bdc"
    sha256 cellar: :any_skip_relocation, catalina:       "400ad597a36fdd45e5333747a9d74b3a98839c9fb1cb3e1b2e62e805fe084b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae411861718b9027c834e28771ad11effc512f69907f58b78a5d852f55ba36b2"
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
