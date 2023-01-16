class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "http://www.chkrootkit.org/"
  url "ftp://ftp.chkrootkit.org/pub/seg/pac/chkrootkit-0.57.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.57.tar.gz"
  sha256 "06d1faee151aa3e3c0f91ac807ca92e60b75ed1c18268ccef2c45117156d253c"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?download[^>]*>chkrootkit v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a258b8d69f0bf8c1dd9b9b23aba20d27949fda98ddee50bbbfa78ebdc55de7c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c6496e1a119f83e5e23fcde469684f5b35266e23508a6e916f912ba1ac3f06f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a119c099a118a185ac8dd5b9fbbaa568c19e59164b09142e244ad17e9deaf5a4"
    sha256 cellar: :any_skip_relocation, ventura:        "2f88f6115544d95e4409f74d5cb4fbde7418c430ce589d5eac8fe2690fb5ad14"
    sha256 cellar: :any_skip_relocation, monterey:       "5c56183f6855ad2d7545bd380828de4c512c53de0d4c1c23f27f35840e284a48"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a41aaede48d1084680b894f295fbf1de375c4ffc0ec86cc170907ff64357634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef592be0764a0d57c7562a57211ebdb64c7f98241a8b7bdd596c57aea9a89e8a"
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
