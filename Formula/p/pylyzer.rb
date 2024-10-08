class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.65.tar.gz"
  sha256 "04673aae114c1db60a807a6ec48b505f3f3df5b830c86195bc3698e481dab621"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c2063488f0680d1a4d55ac394dfd4ea8b1e89eab0690d56ab0f0c1b5a5db2dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7567d7c3e864de13a16769d20aa7bc10f4cf7a0c073e8082e3ecf9cbb96222c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bb1453a3e628d937679ed7f4c248f3f6bd876a99f5bddd1682fc2cccd567e2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "42c777f4a3e801b4c9b52c0a6c3a999a1235ceaa284270819caeb5b74f4b1694"
    sha256 cellar: :any_skip_relocation, ventura:       "3dba65585ba961889d81d2b259967949b8f9efb53b41d618dad288219dffee8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650f85f76a4ff547374b85126081118521ac4ef45ed44034cf7ba4fe909d54ee"
  end

  depends_on "rust" => :build

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
