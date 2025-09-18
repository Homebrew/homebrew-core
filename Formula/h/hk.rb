class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "dce350423b5faa4086f8f1931e728081187831b376a51ced019ecaa29769c6dc"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5faf3da99d97e8febd305661b66b35a97a64e59194858fc0bdbe846f34154ac"
    sha256 cellar: :any,                 arm64_sequoia: "2cfc9b139f0a0b7bb5e4000f9f444ce82e41371fb75a57073a8b5b088ed39e1d"
    sha256 cellar: :any,                 arm64_sonoma:  "56991d287b5c2acaaaed9f59222d52186bdddcceacca8b30e244b3fefb2db5fb"
    sha256 cellar: :any,                 sonoma:        "5a8ca8eb10975c26fc5bb8357a9535e7e2cda2365a212d69b48a63fa6a4e4b34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f149c19d1551f477b22f2c05eaee8e6ad013a512e12b23616d4bc4cd93a451f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff306ea18db72d2f8a5f25ae4ec12e3340f54d59e8e60f58739108bdd9af919"
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
