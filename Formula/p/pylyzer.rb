class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.43.tar.gz"
  sha256 "270c60cdb4e2183553f2f5b48c97c9770b5e8487d460f5f2c41cb74a6fc3def1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "492ce925005b15f6744ce8cd18d30a52bfef5b7deac6e56c2491f820e481d10d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97f2865aef3071ff8645e90ce46a719f564d355fe792b9d0c86f85024abdc0e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d3c0ef02ffd11f35cca003b57f7ceeef560b9c35a770dc0a6dda33dbbf18985"
    sha256 cellar: :any_skip_relocation, ventura:        "2a03df822eccaa19926e81dfd0ad5962509547effdaa1f5606b1bbbc140f7597"
    sha256 cellar: :any_skip_relocation, monterey:       "8a15d987437c1dcf35c8bf4a1042ad008bbeaad8873dd4a4602059266d9100af"
    sha256 cellar: :any_skip_relocation, big_sur:        "2838342a93c06392eff8a4402f9044af7932f456ea4af80a4e925507a9a9e140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b02a30f4b1dacbd9dc76cb40f5a16062e1ec47706c8524257101bf0903acf77"
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
