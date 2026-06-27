class Multitime < Formula
  desc "Time command execution over multiple executions"
  homepage "https://tratt.net/laurie/src/multitime/"
  url "https://github.com/ltratt/multitime/archive/refs/tags/multitime-1.5.tar.gz"
  sha256 "4cef12f00ab0f77a2dcc1dcd2838319cdc125afe3fbf27edcc7b809388b1fa78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2149b8b5cbf1c8628f8363ad1cf3722eb7378aa6ab0f24a767c3bdb881f137bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62e1d329fb812b4643c0b7ceb79ddb031276f4fa1c630147394b83c41ec4348c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0cb19088c612d9c11ad62272d8e08d901f5a346ff14814117ede92912f2f451"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4b4bb4abebed80b593980d28d33dbcceac6373212fa25745f370f099ce340c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de2d74759f5a542b0d7199f9583a52f8c353a709d373749eb4dbdb773f08d60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e402d18c345b4a4e91f8a504ac676129209ce46d5487dc68985dbf5e13907974"
  end

  depends_on "autoconf" => :build

  def install
    system "autoconf"
    system "autoheader"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/multitime -n 2 sleep 1 2>&1")
    assert_match(/((real|user|sys)\s+([01].\d{3}\s*){5}){3}/m, output)
  end
end
