class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.48.tar.gz"
  sha256 "82630523fac721ea5d2a428201dd95c518937ba67471db2638adf4c3f1b3d557"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d2f3249d1e166b4d57ef5720787d6c492cb893c28e1da46bd13cf9e45178f02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40c1edc9134bc07574e109f5695c793e0f23cd6b64b8cd33fb46ca1a1ea019c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f7a5d52474456f02076d2735a3e663551d0eb3d116c694061f37353086f0a23"
    sha256 cellar: :any_skip_relocation, sonoma:         "9907573261f0715749ef8e6050070761a8d58cdb09606f60eec1293323071914"
    sha256 cellar: :any_skip_relocation, ventura:        "a503d9867132026df8ab43d33e46dfa8a345c6e7d23eb0c911793c34162c83e2"
    sha256 cellar: :any_skip_relocation, monterey:       "f9bf6dae44b5003551c3ce8320044c4af68090063989cdd80f028b2a97ddc401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83e971b5af3a860c44c9914058042f881a25bbf0c31fbf08c848fbb80aed3d25"
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
