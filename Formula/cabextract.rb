class Cabextract < Formula
  desc "Extract files from Microsoft cabinet files"
  homepage "https://www.cabextract.org.uk/"
  url "https://www.cabextract.org.uk/cabextract-1.11.tar.gz"
  sha256 "b5546db1155e4c718ff3d4b278573604f30dd64c3c5bfd4657cd089b823a3ac6"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cabextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92ae5d0d2943f9d374dd70ee3b4b60abe8ab33783f45e8ee68dcc3d8df891e3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1e2aa1907ed6a5c635118d2c1756889ab90dc63e110f8d591e8cab644e7dec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c632d89f6f55317494ec0cb8da6c23214dad4f6318d2ce9c6d42f70d6a5a764e"
    sha256 cellar: :any_skip_relocation, ventura:        "c0644e8e20c01a9bf0759cdbf29d05a4e36344cd5945b3a601c4091b22899e5c"
    sha256 cellar: :any_skip_relocation, monterey:       "1c42d09f33a2c75971ee9c6d0f7bce9f36fd73fafa65264dd4299939aa4ba409"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dd9828110287f16b4754f00520eeb096ad5a4336ea32e1e1242bc7899b1ee16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e9c5f98c058dfc91722b07b07973cbc0368080aa7234256d8fc3337373c0ba"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # probably the smallest valid .cab file
    cab = <<~EOS.gsub(/\s+/, "")
      4d5343460000000046000000000000002c000000000000000301010001000000d20400003
      e00000001000000000000000000000000003246899d200061000000000000000000
    EOS
    (testpath/"test.cab").binwrite [cab].pack("H*")

    system "#{bin}/cabextract", "test.cab"
    assert_predicate testpath/"a", :exist?
  end
end
