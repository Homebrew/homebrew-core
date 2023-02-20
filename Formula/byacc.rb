class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20230219.tgz"
  sha256 "36b972a6d4ae97584dd186925fbbc397d26cb20632a76c2f52ac7653cd081b58"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1133953feb9f754f6ee98caf7a51a09a07c30e1ab42431652a50ed378ce97ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd00f777b51a2b01b0550ffce13801826202cb65b15248d4792017ea9a22ece7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eaca62b3031ceef3ca3b35229621b567760c7268dcb86dab51a5259fd3c57951"
    sha256 cellar: :any_skip_relocation, ventura:        "791539cc8a8fda26f5467c6ba0d2065d39691810120e981c67b6ac138a0f6df4"
    sha256 cellar: :any_skip_relocation, monterey:       "7a6c55d033da4f219fe86643adc0237ee4ddbe69f78d1b162bfa49b934325de7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ea83e6e8b1dda90cc2e7d75fd8bf4a53ca63c69915bde3459fd87eccef01b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac332f427626ff40e90a891cf9fdcf8bbc88dbc9559f6d302b674bc1ca71f0fd"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
