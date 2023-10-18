class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.48.tar.gz"
  sha256 "82630523fac721ea5d2a428201dd95c518937ba67471db2638adf4c3f1b3d557"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af821b35425dd96e2b37ed57f61529dd7069124be3dcf4a5d2c5b98b462f71a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbd8a9da5666a57b721af3d3bf57cba47d0cb34d4235ed3e0f56c0ee8a66396c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6baaa1e9888a54a785cb60b31084a004e585a54a9dd116890ad01c27fdaaf1c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e3cfda82bffd6386e9af21cc8fce59a826202aaf111987fa85fbd98e2034179"
    sha256 cellar: :any_skip_relocation, ventura:        "00daf94923253436df78c2f749704d8ece51fc94eca2763a6d4118fd72d8763f"
    sha256 cellar: :any_skip_relocation, monterey:       "7a6ddf57d8dcc5afbb055902ca3939d86e9484126b32e20de3fb09f5c52eedec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a44e0ffd4111f88053b063c8137eff10500471abcc6d056961656f1cdee347f"
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
