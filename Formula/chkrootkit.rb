class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "http://www.chkrootkit.org/"
  url "ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit-0.55.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.55.tar.gz"
  sha256 "a81c0286ec449313f953701202a00e81b204fc2cf43e278585a11c12a5e0258b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?download[^>]*>chkrootkit v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59a2d7c6798a78d907c269ab5ed9effdc111e4ff6b4dd7e5bd65ed3721846c72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a0131227a3d12132068de046c3a7fa851a452bae907c635a92a484868977104"
    sha256 cellar: :any_skip_relocation, monterey:       "818406aced3c057489cea7395219de7aeff1c7da9e2b3218939d291c21595c72"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fac603ca267b72c2882d460a458957f843a5e821fb0406d6230d42f1fe0557b"
    sha256 cellar: :any_skip_relocation, catalina:       "a181e6fe3a682bfb24742eac3823e3be8fa531e18954e99b02098bb7c43323fb"
    sha256 cellar: :any_skip_relocation, mojave:         "dcb47fe6461d30ac9088466a4681eca173863767a6336965dee128e35bcf8c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a1d5b23f87e71487ee2a4594ad9e9293791761158867903c574bfd89c9f2ba0"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "STATIC=", "sense", "all"

    bin.install Dir[buildpath/"*"].select { |f| File.executable? f }
    doc.install %w[README README.chklastlog README.chkwtmp]
  end

  test do
    assert_equal "chkrootkit version #{version}",
                 shell_output("#{bin}/chkrootkit -V 2>&1", 1).strip
  end
end
