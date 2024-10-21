class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.68.tar.gz"
  sha256 "4902770d90c170d7e680259affb799eeae81333274c37283e5056e94b8c5aafa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21eaaa9aa7b12d2b8011e3f11d8b1073935545ea16ae0e01112d75f7302eb460"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1827f95f0e09b4630fbcceed4436323b5833e84373d842f0c9496aa418d58b78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e5715765ac42714e8e3abda929fce25285a6cbaa668424aab4c2e6187d671c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d38ac015c602e1466d066714f623be2cf355a56f17509bcc98348f0a04b1ed1f"
    sha256 cellar: :any_skip_relocation, ventura:       "a5e01ee925ddca5adaabb1d4d1405bf3aed0216313c86035727600cb0b1436e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73f1cae489201a05d4c61a10c9bc2978111db0698e558e47461e8f1beb395088"
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
