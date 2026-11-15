class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-5.9.tar.gz"
  sha256 "0ef2ce7db728167844a91904944cd07c7ccc6fd3041b849cad861224d106a845"
  license "ISC"
  head "https://github.com/eradman/entr.git", branch: "master"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2684ccbd205b2b06eb1aa1174eab33c6db1a25e56fca6ab50cd4700dfebc28bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "44320e4d824dc977fadfc1c871bfd1a604e6a48f073be0c1263add9c8a499607"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8af3d28815a4024e15fd973d1558e59b7264dd0ed79775d4b43382f9b48701b7"
    sha256 cellar: :any,                 arm64_linux:       "78ae395c02f3e5f8451d1ae35bedcd03b6a077896c78f76b206903d053442d56"
    sha256 cellar: :any,                 x86_64_linux:      "28eaca5c84b0952841d9615f9464ddfea9e6aef0da23477641f78dee9563da4e"
  end

  deny_network_access!

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 2
      touch testpath/"test.2"
    end

    assert_equal "New File", pipe_output("#{bin}/entr -n -p -d echo 'New File'", testpath.to_s).strip
  end
end
