class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.53.tar.gz"
  sha256 "ae6c0fb486fe6eccdfbbdaead14f3d57390330c69f89d4ade8f24a7a723bbc1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e56f9219f479c161542a4148c9d2fab36e191c0421c70e8f28804bdfaa2e1d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4c057e34218728cd934029a19e6a3e9d8c0232ba3db6f4f0af871f58c2375a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89d383f8e293c458feab840a9b8d79fe21b4dc86bcd5295bc87cfaf3f03ac7a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "08d083badf8dcad70865228a02747f7033a85e8203dd23fc92a575355e52d338"
    sha256 cellar: :any_skip_relocation, ventura:        "5ad30839d4cfdc9a2998ae5f76be77ca236f4631d47ac0a8646a88684ddb65de"
    sha256 cellar: :any_skip_relocation, monterey:       "cfea9299aa29c43c6185d388e8ebdb98dfe49182ffffd0563d2e7ec9df0764e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d20a108a4932c4e839af090cb14d08c4d7e64534989f75e716aa7941d07dec1f"
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
