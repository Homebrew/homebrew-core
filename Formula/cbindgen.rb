class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/eqrion/cbindgen"
  url "https://github.com/eqrion/cbindgen/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "5d693ab54acc085b9f2dbafbcf0a1f089737f7e0cb1686fa338c2aaa05dc7705"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7138c40d52a94efd75576d132c6575c869c6ac0dec342e637e75c52a1d4b76d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0c1a36521b5e49fcaf8a6926a17495273312e28ba8dd5e9595bf8f02884ae5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aaefb1afec80860483ed1561f2da6f6f76c2a9b7f76064ff7c63632d433bb294"
    sha256 cellar: :any_skip_relocation, ventura:        "7a1088dcd007b9a951598ee3935bff600d769043ebde5d46bcc1544636d80980"
    sha256 cellar: :any_skip_relocation, monterey:       "a25cc4ddd2e539f7fed0c848494c4139c77519cb6b9e72958312b25fb27fc5bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e2be90e9b02046436ff3bc7934966b44a35145f61bea72c5f9441fe52072306"
    sha256 cellar: :any_skip_relocation, catalina:       "b0b28803e7fcc5cb41fb207196fbc40790d6553d5c7834769e1ddf769e8b7e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d7487e947535b4a520343029d23d4878504e8570b8f23d00b25882c15fd5d26"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/rust/extern.rs", testpath
    output = shell_output("#{bin}/cbindgen extern.rs")
    assert_match "extern int32_t foo()", output
  end
end
