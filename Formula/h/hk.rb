class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "e533b9664673333bfc1abf837d052d435aa88ca76a8fa2b61332701118110368"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3acee0a2b3e1e159e6e20615791307eddfdeb8af490ee692ac5f1f62217b4a82"
    sha256 cellar: :any,                 arm64_sonoma:  "56be2c05ce36e4ccd21dc72bcf25d93356e2b15cc4448f7334b85e8dedb76144"
    sha256 cellar: :any,                 arm64_ventura: "1ce0b36dd0f4c1e9c47634bb7ccba343972c97f5b3d1e0cf488527002d887f66"
    sha256 cellar: :any,                 sonoma:        "d4ca424a99a8f178932660e8e6f80d6d058eb8110a1da22f472b798a6ee560c0"
    sha256 cellar: :any,                 ventura:       "7801eb1359ca2b3e59f854d54ec7bb8aa3a84634e93cc22417bf0ba414f3c1be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da6ff17c34633e62aa54cf7a1234670a85043be2469befa78113f765b0a7938e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d172b4de7ffbf0ea8f2a066ce0743703e6678d1574209f8f30a6315549cdc5"
  end

  depends_on "rust" => [:build, :test]

  depends_on "openssl@3"
  depends_on "pkl"
  depends_on "usage"

  uses_from_macos "zlib"

  def install
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
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}/hk run pre-commit --all 2>&1")
    assert_match "cargo-clippy", output
  end
end
