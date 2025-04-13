class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.8/psysh-v0.12.8.tar.gz"
  sha256 "3119a55735845612f889baff63a9b96d54e1f63c18d8426f685cd3055ed33a01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7af2ac0c32da2877143af8acdd102ca56dbf11939c69447ca6c667a4919a09e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7af2ac0c32da2877143af8acdd102ca56dbf11939c69447ca6c667a4919a09e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7af2ac0c32da2877143af8acdd102ca56dbf11939c69447ca6c667a4919a09e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ac72659f7e05d491e23124f7acc8c8379ada20040bfee36e056db2a136ddfb4"
    sha256 cellar: :any_skip_relocation, ventura:       "4ac72659f7e05d491e23124f7acc8c8379ada20040bfee36e056db2a136ddfb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7af2ac0c32da2877143af8acdd102ca56dbf11939c69447ca6c667a4919a09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7af2ac0c32da2877143af8acdd102ca56dbf11939c69447ca6c667a4919a09e"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~PHP
      <?php echo 'hello brew';
    PHP

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end
