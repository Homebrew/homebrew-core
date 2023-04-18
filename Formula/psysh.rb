class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.11.15/psysh-v0.11.15.tar.gz"
  sha256 "93306871291df3bbd26403c76c4e43f6be571799695b6bd7a512dacf3feaf3af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "656029e3a08afd235388abbb13111d663422951fc9a7ad3159ee1105a2e5bf73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "656029e3a08afd235388abbb13111d663422951fc9a7ad3159ee1105a2e5bf73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "656029e3a08afd235388abbb13111d663422951fc9a7ad3159ee1105a2e5bf73"
    sha256 cellar: :any_skip_relocation, ventura:        "8feaa674b6413549e64997f554964e632566ac6448d924d5cd06923d38674195"
    sha256 cellar: :any_skip_relocation, monterey:       "8feaa674b6413549e64997f554964e632566ac6448d924d5cd06923d38674195"
    sha256 cellar: :any_skip_relocation, big_sur:        "8feaa674b6413549e64997f554964e632566ac6448d924d5cd06923d38674195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656029e3a08afd235388abbb13111d663422951fc9a7ad3159ee1105a2e5bf73"
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
