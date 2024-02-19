class Jose < Formula
  desc "C-language implementation of Javascript Object Signing and Encryption"
  homepage "https://github.com/latchset/jose"
  url "https://github.com/latchset/jose/releases/download/v12/jose-12.tar.xz"
  sha256 "0ba189b483f27899867fdd886eda42dd9d17b807ffdc7819822665cb45d7e784"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5ab1d6d35f6489c7ee29f67ae59cff675657024b9456e9c0437b82d63def577a"
    sha256 cellar: :any, arm64_ventura:  "6ed6cda62ae66cd159c81ea7fd1cf465755d3ab7494701f0aac6ace4fc3991bb"
    sha256 cellar: :any, arm64_monterey: "139a737ba296a4d24e680decdf3daf9a1276836b22aec2493a7c9625234602a0"
    sha256 cellar: :any, sonoma:         "c51afd0ee639305c12bc69b03b8583ff9c6e4289fb0050ecae55e6e18f57944f"
    sha256 cellar: :any, ventura:        "88e802405401cbd382a56bd6c7b17d4d604bf76351d07bb46dea75ee11cdaf4a"
    sha256 cellar: :any, monterey:       "cdeb4abd78ee95d1663ec47da5a54801edab0dd6f618749d7af02dfcec4cd9d3"
    sha256               x86_64_linux:   "3b7cbdea2a9554c0f2ff87359ceb73e73ab35f2455147d98cdf7cfcbe2b7fc29"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"jose", "jwk", "gen", "-i", '{"alg": "A128GCM"}', "-o", "oct.jwk"
    system bin/"jose", "jwk", "gen", "-i", '{"alg": "RSA1_5"}', "-o", "rsa.jwk"
    system bin/"jose", "jwk", "pub", "-i", "rsa.jwk", "-o", "rsa.pub.jwk"
    system "echo hi | #{bin}/jose jwe enc -I - -k rsa.pub.jwk -o msg.jwe"
    output = shell_output("#{bin}/jose jwe dec -i msg.jwe -k rsa.jwk 2>&1")
    assert_equal "hi", output.chomp
    output = shell_output("#{bin}/jose jwe dec -i msg.jwe -k oct.jwk 2>&1", 1)
    assert_equal "Unwrapping failed!", output.chomp
  end
end
