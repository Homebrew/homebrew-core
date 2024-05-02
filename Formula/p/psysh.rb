class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.3/psysh-v0.12.3.tar.gz"
  sha256 "49147b029193027653a75b361881e7a5271905019d377fd901ba5c48a4b1685d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5189d5165f42d30fb51c3b9d8469d1af7ab7b21bcd2ed7f4374831e0961e6c34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5189d5165f42d30fb51c3b9d8469d1af7ab7b21bcd2ed7f4374831e0961e6c34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5189d5165f42d30fb51c3b9d8469d1af7ab7b21bcd2ed7f4374831e0961e6c34"
    sha256 cellar: :any_skip_relocation, sonoma:         "54ef6d7c1e404fe73f5d872490ed9827703148f4e13b63481db9069c3e2f1a06"
    sha256 cellar: :any_skip_relocation, ventura:        "54ef6d7c1e404fe73f5d872490ed9827703148f4e13b63481db9069c3e2f1a06"
    sha256 cellar: :any_skip_relocation, monterey:       "54ef6d7c1e404fe73f5d872490ed9827703148f4e13b63481db9069c3e2f1a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5189d5165f42d30fb51c3b9d8469d1af7ab7b21bcd2ed7f4374831e0961e6c34"
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
