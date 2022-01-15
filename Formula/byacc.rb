class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20220114.tgz"
  sha256 "d131475970018ab03531ce1bac21a8deba0eea23a4ecc051b54c850dad69e479"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbba9bb6cde3ced15e205d88eb78c95691914e860286aa10eae6f205c634b7e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bde6b5e07a4c4740ceb3f274e70ed18e1804cae7e00a4bd6b9fde3c7bfc42c49"
    sha256 cellar: :any_skip_relocation, monterey:       "bcb7fae2ff4fc911b7438c09eef58b40c439c370443a75875719358c09b8a66e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cc12dbb394fd134736fd8f1ead653ef23b280912f6305a26f67a63b274bbc7c"
    sha256 cellar: :any_skip_relocation, catalina:       "ff2b4f0e1e054c04556f06af0792b0b6c1d0ce6d40171216a3714b4c692efffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c06f1fba34b4e2bfef4aa65fa2fc9842c07e433e3475a411bd94065a062c3080"
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
