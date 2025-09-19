class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "a055a9ee70c2ac48bdb9b01c597e1c2bdd997b1acf5bf023a341a4ed98e08e8e"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7844598a5b6bf3597e7c70bcf0bddc35f0127d90e5b5b441e704093fc52a2a02"
    sha256 cellar: :any,                 arm64_sequoia: "7187d1b22cb287d987066736d6b081cb6da1ea937c4844db900fc25207d1f7b1"
    sha256 cellar: :any,                 arm64_sonoma:  "0c5fb0605bb7ee71cadf5b09b6daa95c77fdece01280fb4709a1b1bb6c200d49"
    sha256 cellar: :any,                 sonoma:        "2c8b1618478c931d64e5e7de500be6d727265f45ed0832c4d7ebc806780e962d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76c61358a472723b406ac1bafdf18199cc9bd1c7f6431796ecea470064ce0f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eeae1f02a469788f85a3cffb04716489c4c27c84be0d562a6bcba7828e9aea8"
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
