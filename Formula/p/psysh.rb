class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.10/psysh-v0.12.10.tar.gz"
  sha256 "f72a352f9f744fca3a01c5078269ee303d7eb775514c108a9404bc4927418190"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "570405c19eb330a12167a5b2a9c79a4f026d0247ed2ee3e6ab176fcfdf842afd"
    sha256 cellar: :any_skip_relocation, ventura:       "570405c19eb330a12167a5b2a9c79a4f026d0247ed2ee3e6ab176fcfdf842afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d43a18dee47ac4018167d10d7014d73ae48f2f3962449e4921893ac6fdb405f5"
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
