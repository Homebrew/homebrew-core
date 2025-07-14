class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.9/psysh-v0.12.9.tar.gz"
  sha256 "67c4f2c1c3fcf32177b0b740f0cf97818e6abc888ab2bfbde8a270b72371d630"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fcbe60c7c8061b73002734ee99c45340a6bb8021ef13fc3a332f5bb253c4c7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fcbe60c7c8061b73002734ee99c45340a6bb8021ef13fc3a332f5bb253c4c7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fcbe60c7c8061b73002734ee99c45340a6bb8021ef13fc3a332f5bb253c4c7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "41572ae18ef058a3b6d20b955d50170737bbebcf882e44bf2f06e603032922c3"
    sha256 cellar: :any_skip_relocation, ventura:       "41572ae18ef058a3b6d20b955d50170737bbebcf882e44bf2f06e603032922c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fcbe60c7c8061b73002734ee99c45340a6bb8021ef13fc3a332f5bb253c4c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fcbe60c7c8061b73002734ee99c45340a6bb8021ef13fc3a332f5bb253c4c7e"
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
