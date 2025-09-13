class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "8921952478b496e8f615e75efa86fe8343e2d44538d4cfcb24ac06f499beab19"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a6b1ef9c29a5dfb21d412f4c9bdd37ec99a0b0d5b9bca641a095eab5a7d47a3f"
    sha256 cellar: :any,                 arm64_sonoma:  "79a0acf831d4836b4f5542e13092715cfaee1c6be21262cf68af49ddebd65e29"
    sha256 cellar: :any,                 arm64_ventura: "b828e80c74af81dffbf545d4fb0d6367899bb906d00c7c1fbf7251011cc31afe"
    sha256 cellar: :any,                 sonoma:        "5a6b6bf376dd317bffdd5c5565be512b45ca549143d1078e51256c15a5af4659"
    sha256 cellar: :any,                 ventura:       "d866397d69ed3fffbb0048bb6c9e2111995de4526f45dec21448d47f12478f8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa380965c4fb87feb8e1bca4af641f6eb0f4f53584e36fb156809f2b147b70ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a50b323319e85946965fdd44a660225c8b6fb1c3fc660694719bb174f000832"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  resource "clx" do
    url "https://github.com/jdx/clx/archive/refs/tags/v0.2.19.tar.gz"
    sha256 "b06f39d4f74fb93a4be89152ee87a3c04a25abb1b623466c6b817427a8502a73"
  end

  resource "ensembler" do
    url "https://github.com/jdx/ensembler/archive/refs/tags/v0.2.11.tar.gz"
    sha256 "967f98f6dfd19b19e0aa91808ea5b81902d3cd6da254d0fdf10ffbaa756e22bb"
  end

  resource "xx" do
    url "https://github.com/jdx/xx/archive/refs/tags/v2.2.0.tar.gz"
    sha256 "cccdca5c03d0155d758650e4e039996e72e93cc1892c0f93597bb70f504d79f0"
  end

  def install
    %w[clx ensembler xx].each do |res|
      (buildpath/res).install resource(res)
    end

    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hk", "completion")

    pkgshare.install "pkl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hk --version")

    (testpath/"hk.pkl").write <<~PKL
      amends "#{pkgshare}/pkl/Config.pkl"
      import "#{pkgshare}/pkl/Builtins.pkl"

      hooks {
        ["pre-commit"] {
          steps = new { ["cargo-clippy"] = Builtins.cargo_clippy }
        }
      }
    PKL

    system "cargo", "init", "--name=brew"

    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
