class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.12.4/psysh-v0.12.4.tar.gz"
  sha256 "785bddd5650694d9b4d051869a175392f9faac327687ee8a81af0305083072df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e29133c37afee0eb7bb82e3ec24de92452ce1a4972aa87b2762d482ffad1f91c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a9ad18d62be203e22c1ada2988285cd9818e56e3e733b6fe55885b131055867"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a9ad18d62be203e22c1ada2988285cd9818e56e3e733b6fe55885b131055867"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a9ad18d62be203e22c1ada2988285cd9818e56e3e733b6fe55885b131055867"
    sha256 cellar: :any_skip_relocation, sonoma:         "68803a0946a7f26f35dc444401d13686a399842cd6e5aac0ac8270283ee9780f"
    sha256 cellar: :any_skip_relocation, ventura:        "68803a0946a7f26f35dc444401d13686a399842cd6e5aac0ac8270283ee9780f"
    sha256 cellar: :any_skip_relocation, monterey:       "68803a0946a7f26f35dc444401d13686a399842cd6e5aac0ac8270283ee9780f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e711d7a1c572b92355f0279e0e9970e37e296defe7719ad232bb8023cca322f5"
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
