class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony.tuxfamily.org"
  url "https://download.tuxfamily.org/chrony/chrony-3.5.tar.gz"
  sha256 "4e02795b1260a4ec51e6ace84149036305cc9fc340e65edb9f8452aa611339b5"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9dcac360bb8b69012e963df7dcf34fa50b944bd419ce4d9c28d729cc6787ce4" => :catalina
    sha256 "946bc4e955230a22006204b3bea76ae4f5b3bd186f94fad91e3fc4d5c10b7a02" => :mojave
    sha256 "856b8ccc137b877687e7054b28e160b0ecd7b5b94a76b6d4a6978258dbf619e4" => :high_sierra
  end

  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.ntp.org iburst\n"
    output = shell_output(sbin/"chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match /System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output
  end
end
