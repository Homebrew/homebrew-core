class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/chneukirchen/nq"
  url "https://github.com/chneukirchen/nq/archive/v0.5.tar.gz"
  sha256 "3f01aaf0b8eee4f5080ed1cd71887cb6485d366257d4cf5470878da2b734b030"
  license "CC0-1.0"
  head "https://github.com/chneukirchen/nq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d83603cb3ce3154dfd187f9d9718d006344c92adab6dde6baa37ffe0cbebd1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70578036134f31e789368935f42818ca3d081f24f35834e4a46a3aee4fe7e019"
    sha256 cellar: :any_skip_relocation, monterey:       "09570b0ce3036025efc94f1d3a938b333f0412ec03cdf5e5f7df149a65c02a3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9b781b0ab4cfa2b90c9c64a7927cf37ab708c807fea1209f4e2e23a216b9b05"
    sha256 cellar: :any_skip_relocation, catalina:       "4d04dbda77c205fd4f66723b26adb4b0068e3f507b0eba389a0829edb23bf787"
    sha256 cellar: :any_skip_relocation, mojave:         "b72eb755d197833093fe7bf5f35c7d07fb6cee203354b48d38721885f7d94315"
  end

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/nq", "touch", "TEST"
    assert_match "exited with status 0", shell_output("#{bin}/fq -a")
    assert_predicate testpath/"TEST", :exist?
  end
end
