class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.2/psysh-v0.12.2.tar.gz"
  sha256 "18c4f9001833fbbb9c3dd123deea652c98e7f2f9feaec12073c4afa4213dd806"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72d6fbdd505aed3dd5e1280ed4055f44cbc1e114c7185f07f7199ea4686c7ff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72d6fbdd505aed3dd5e1280ed4055f44cbc1e114c7185f07f7199ea4686c7ff1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72d6fbdd505aed3dd5e1280ed4055f44cbc1e114c7185f07f7199ea4686c7ff1"
    sha256 cellar: :any_skip_relocation, sonoma:         "6be22c18c7050ade81ec7235608eb89362e76734e86dd36ba06acc0772b2c644"
    sha256 cellar: :any_skip_relocation, ventura:        "6be22c18c7050ade81ec7235608eb89362e76734e86dd36ba06acc0772b2c644"
    sha256 cellar: :any_skip_relocation, monterey:       "6be22c18c7050ade81ec7235608eb89362e76734e86dd36ba06acc0772b2c644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d6fbdd505aed3dd5e1280ed4055f44cbc1e114c7185f07f7199ea4686c7ff1"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~EOS
      <?php echo 'hello brew';
    EOS

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end
