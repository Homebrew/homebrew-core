class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "d24bc83793b225409372745fb160bd8a8cda8ecc70b443ab2cb875e1a18b0f06"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7be79c6f9cfddacb50c6de7454b9a6cd064f8242c0ae024a39d72bfcbb4d1518"
    sha256 cellar: :any,                 arm64_sequoia: "c3b369a3358c7b6c8894de4b5ab8fa3ccb19a18744c41aca67f1084f655a6fcf"
    sha256 cellar: :any,                 arm64_sonoma:  "451efe308484ce5d808890d630fec6a411e637bfd6ee9d81f27e1a80ca0023bf"
    sha256 cellar: :any,                 sonoma:        "eb7992d0ae92dd3adf56f958d89517d90571aaa6ac064a40fa4185e5e06cdba0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d77f070f8d9bebbc060c7620b8067bb92e2f69eabdc419b4ab917a4dd1bcb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51d8c0ed821067e404bfc4144067fbf42e5616e6c526778403edec4db29b5326"
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
