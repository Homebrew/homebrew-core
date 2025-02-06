class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.78.tar.gz"
  sha256 "a9ffaa881f9d40b64ee36b8c93f59d1b0f4bbc0af57814f611b2bae97d84f876"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f6235769ea9a432058948617d5d76ae4fde5a8bffaa95f70fc4768322c8b495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "812ac340c39029063c5477b82aaa6fdbe765ab91f9ec87cc4def8bcbf0425eaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "175499bc4895b9f6bdfb124e05d931646c359543beb7e9fb2e47a81397e9f9ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d8e4ffe7deb7d0679aeeb15357048bdb92ee8f0c6392f1b1819c347a5cdac11"
    sha256 cellar: :any_skip_relocation, ventura:       "eee6299762040c3549c93f5ea2476bceeb737db117349204a1bb24f4552c1fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd7433ec1c034947c8a6f2b5b98307c32a042739123ee0e22397feae847c43f6"
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
    (testpath/"test.py").write <<~PYTHON
      print("test")
    PYTHON

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end
