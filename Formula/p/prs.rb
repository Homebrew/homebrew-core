class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://github.com/timvisee/prs/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "9a4cc8371ec166c0a62da12cdb2c5e053fe399c49b026dea9c67258546630abe"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a93fda36c4e71d0530ff82829b8834ca2798503b07ddbd215736a99c5692d45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1f84a217868717c2d34388ab151d771f6cb1366c03e9113600c710dcec8731d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ebb272933f7017e878eafbf46a779451361504a38dfbf4701b8daf0b2b96376"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fc865fed685cba423c806c8501a9439fc91cdbb579714696cab3569063625f2"
    sha256 cellar: :any_skip_relocation, ventura:        "dbb75b374a81e5246790a9df5bc90b10353ca0b82cafc7843d3b601809b5d96c"
    sha256 cellar: :any_skip_relocation, monterey:       "8c1a4619c349cad988a4e83b406b7054b45f675a201fc515dd74c76088de4c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74dbee9d5ae9011d4adf16ab1723a0200842b304f443900865fae59be2877ac2"
  end

  depends_on "rust" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"prs", "internal", "completions")
  end

  test do
    ENV["PASSWORD_STORE_DIR"] = testpath/".store"
    expected = <<~EOS
      Now generate and add a new recipient key for yourself:
          prs recipients generate

    EOS

    assert_equal expected, shell_output("#{bin}/prs init --no-interactive 2>&1")
    assert_equal "prs #{version}\n", shell_output("#{bin}/prs --version")
    assert_equal "", shell_output("#{bin}/prs list --no-interactive --quiet")
  end
end
