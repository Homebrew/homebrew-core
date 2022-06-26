class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "https://github.com/erkin/ponysay/"
  license "GPL-3.0"
  revision 7
  head "https://github.com/erkin/ponysay.git", branch: "master"

  stable do
    url "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz"
    sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"

    # upstream commit 16 Nov 2019, `fix: do not compare literal with "is not"`
    patch do
      url "https://github.com/erkin/ponysay/commit/69c23e3a.patch?full_index=1"
      sha256 "2c58d5785186d1f891474258ee87450a88f799408e3039a1dc4a62784de91b63"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf1695638d599e7bca5b59a6a1d15e4a9555fef2a64a8b57a680af46a578fbdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15d31809c411d0af2a1aa8d1d2590e061ab4cb9b9de0397e97be2ebbb01e1fc8"
    sha256 cellar: :any_skip_relocation, monterey:       "919db1ea7b08a3bf90d2950e428bb845b0a490803b336c15aa55ee7470405897"
    sha256 cellar: :any_skip_relocation, big_sur:        "bde757a6e76ce24cf5f8b163e3c6046032ea486c25b707140c8eb0e117fe2148"
    sha256 cellar: :any_skip_relocation, catalina:       "599a4e15aa4b45a57a2a49a1dd961ab92ea763fd176552ffa278a7f0f4908a92"
    sha256 cellar: :any_skip_relocation, mojave:         "6c163cdc7026773234e757c83135d848ca2447e2e160d5d2fa12761e64bdda5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d7c805cc2d40f173cd617bef3d846c6858564e398b595271f23436608ad6e36"
  end

  depends_on "gzip" => :build
  depends_on "coreutils"
  depends_on "python@3.10"

  uses_from_macos "texinfo" => :build

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "--with-custom-env-python=#{Formula["python@3.10"].opt_bin}/python3",
           "install"
  end

  test do
    output = shell_output("#{bin}/ponysay test")
    assert_match "test", output
    assert_match "____", output
  end
end
