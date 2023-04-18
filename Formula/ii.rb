class Ii < Formula
  desc "Minimalist IRC client"
  homepage "https://tools.suckless.org/ii/"
  url "https://dl.suckless.org/tools/ii-2.0.tar.gz"
  sha256 "4f67afcd208c07939b88aadbf21497a702ad0a07f9b5a6ce861f9f39ffe5425b"
  license "MIT"
  head "https://git.suckless.org/ii", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?ii[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea782f684a234374c02653e45ba15f4f08b8472cbb2e623eff6ed407f31a63ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b690908cae6529a5196b469c91a53702562da0fbd27025aade6c9b18c853447"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c34f6e709a97a2146181e6cde6af9e4917ba655cf053f96a6da2cc92c57fbb1"
    sha256 cellar: :any_skip_relocation, ventura:        "781ebafbbff7496ee5eebbef4751e1c0490f22f7f76b208a13e2b7d931f27f37"
    sha256 cellar: :any_skip_relocation, monterey:       "5e5d3163eedc2edc9c94fe7bb0d0131748b73d48696c742b34f2f1cf8492377d"
    sha256 cellar: :any_skip_relocation, big_sur:        "de3668d67aaaf8cd68d4a65afb5c0814e47e81516053c98ce1acac8cf0cdccda"
    sha256 cellar: :any_skip_relocation, catalina:       "1a3272d46510c5313a2133b4024f35dedf0f566c3b52592a29a2aaa4fa9e9e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2dbf5ccf220ff7c74c9c409f2ed36465f28fe20ab14d42e62b8df2499b5c320"
  end

  def install
    # macOS already provides strlcpy
    if OS.mac?
      inreplace "Makefile" do |s|
        s.gsub! "-D_DEFAULT_SOURCE -DNEED_STRLCPY", "-D_DEFAULT_SOURCE"
        s.gsub! "= strlcpy.o", "="
      end
    end

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    port = free_port
    output = shell_output("#{bin}/ii -s localhost -p #{port} 2>&1", 1)
    assert_match "#{bin}/ii: could not connect to localhost:#{port}:", output.chomp
  end
end
