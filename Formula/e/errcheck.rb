class Errcheck < Formula
  desc "Finds silently ignored errors in Go code"
  homepage "https://github.com/kisielk/errcheck"
  url "https://github.com/kisielk/errcheck/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "f8b9c864c0bdc8e56fbd709fb97a04b43b989815641b8bd9aae2e5fbc43b6930"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c4ea6a127a1def32d14932e18f61ed0bd47baf99381a8ad2f52a4ce7b8c6410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a28fa11b557c5b8029e19b47c3d4e1bf0c84b3e5c7ec8cbf8ef3a4b129817921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a28fa11b557c5b8029e19b47c3d4e1bf0c84b3e5c7ec8cbf8ef3a4b129817921"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a28fa11b557c5b8029e19b47c3d4e1bf0c84b3e5c7ec8cbf8ef3a4b129817921"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed13edd4e27afb11bf4999389c4a3e74194a0e2c0c9b0a30fd131ceedc840cce"
    sha256 cellar: :any_skip_relocation, ventura:       "ed13edd4e27afb11bf4999389c4a3e74194a0e2c0c9b0a30fd131ceedc840cce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bfbd3a1fa6287c3dc2cff31b3519eeec48e06106b887b7864d9d6d99ad494aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03aca5016fac06782d5ab9016ef333862fb6b9c9a7e6da85417244be7108fd5a"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args
    pkgshare.install "testdata"
  end

  test do
    system "go", "mod", "init", "brewtest"
    cp_r pkgshare/"testdata/.", testpath
    output = shell_output("#{bin}/errcheck ./...", 1)
    assert_match "main.go:", output
  end
end
