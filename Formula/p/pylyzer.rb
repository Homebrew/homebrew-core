class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.47.tar.gz"
  sha256 "0c497a2560cadf0290659242c0da3f710502ba5cc95cccc2f2f70e4a732d2991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83db319520e98f933bb58e405c7575d072312f0606347b767f4094f0fb2324e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ba7b28734a1c662d23436153aaabadb71fb1cad2766e613140cd30dc2c1407b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2153b256d6db335ec074bcd78ef71fa07295524c8325efa55c84857c09ca3942"
    sha256 cellar: :any_skip_relocation, ventura:        "9cab1c6d5af41ca55effccea6986fae5d2eee2738d0942ba79c4203204940b3e"
    sha256 cellar: :any_skip_relocation, monterey:       "b9a52afbe1d0d942885a32ff8f616763d4f02ef0ea79913f4ee6aad8da986bb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b10c5d08b94a9cbd2830486f1be5f28701aa76593e53149624550e7baaa236bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27f6babd4d6cfe6780a4f7e97ff7892bae92a36e422f57c394d6240dc19f163d"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"

  def install
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec/"erg"
    erg_path.install Dir[buildpath/".erg/*"]
    (bin/"pylyzer").write_env_script(libexec/"bin/pylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath/"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end
