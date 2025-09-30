class F3 < Formula
  desc "Test various flash cards"
  homepage "https://fight-flash-fraud.readthedocs.io/en/latest/"
  url "https://github.com/AltraMayor/f3/archive/refs/tags/v9.0.tar.gz"
  sha256 "569ec069dc3ec1c74d90d6704aa8b7f45240f5998a9dc6f14f1736c917506ecb"
  license "GPL-3.0-only"
  head "https://github.com/AltraMayor/f3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9541531abfbf7e8c79f740bc06a5a2107695b2d1fa19f33f6e922b9be036df9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed686149cfd98b9c7a128f67a438f6c81f3152b2cd489c17fe71d40860e16dcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda03bf5e9f24ec222a8e810161fdb6ce221b743c1be7518bc1545381efd0eeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdf1c3fcb4d780f7d6da97a625764de7a8f9f7b5053cc58e322a6a0a6d4c1610"
    sha256 cellar: :any_skip_relocation, sonoma:        "d65dce42f18c8a59d8781b2fa2c8cb9670634c15106024389b8b0ca5f198935d"
    sha256 cellar: :any_skip_relocation, ventura:       "36456dbfc00ea0cac1c8072d91535040fb346a3eaad2f7ed800f0020718c16e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab11a198e8d6ebee4516030645f9a453842d7a9fa8340f53f4b04f27b447f57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcc0ea6c324939671b57a2f951d616372e6f0b4897d9fb0043128b18225ba36e"
  end

  on_macos do
    depends_on "argp-standalone"
  end

  def install
    args = []
    args << "ARGP=#{Formula["argp-standalone"].opt_prefix}" if OS.mac?
    system "make", "all", *args
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system bin/"f3read", testpath
  end
end
