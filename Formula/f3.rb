class F3 < Formula
  desc "Test various flash cards"
  homepage "http://oss.digirati.com.br/f3/"
  head "https://github.com/AltraMayor/f3.git"

  stable do
    url "https://github.com/AltraMayor/f3/archive/v7.0.tar.gz"
    sha256 "1aaf63cf73869633e7e03a2e12561a9af0b0fbba013a94b94e78d2868f441d71"

    # Set up flags for argp-standalone; will be in the next release.
    # https://github.com/AltraMayor/f3/commit/5ad4130088f183e61ba90ff38af1eca614d89eb2
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/35d20ef38ad66e386c0fee34187f5173226377a7/f3/argp_flags.diff"
      sha256 "eeeb70616c23e43db0a52b2c6758325aeb52b663117a7684dcb1436d04a24a05"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d369cb856bab428b9bf17049f0331ad9c1a7154088433887ec141054bb4bab74" => :high_sierra
    sha256 "e11bf7b13aba7ad198486aca8a3edccae5fbaaedff47d6b51f0147cbac4a5d04" => :sierra
    sha256 "47474e4cab315cf4f3dd124a133fc17f4547e7cb111d630e79131ea1f572f36f" => :el_capitan
  end

  depends_on "argp-standalone"

  def install
    system "make", "all", "ARGP=#{Formula["argp-standalone"].opt_prefix}"
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
