class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https://hk.jdx.dev"
  url "https://github.com/jdx/hk/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "eda4266979b5b37bf1ca3ad2078ef8c0c7d65dfeae51dd0ae70bb8ff1eb397ba"
  license "MIT"
  head "https://github.com/jdx/hk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "652dbd2e0c4fa4359a94b59f84c4a010c316d4394f19d5375ace44d1ad6a4068"
    sha256 cellar: :any,                 arm64_sonoma:  "df23c547970831e28571062a8eb4c3805804367f361503568873e35b515902ed"
    sha256 cellar: :any,                 arm64_ventura: "17e5a8b3d28ee4ba2be7c20efb389ccf9b98dfbf8b9202ce78466bf91df21f90"
    sha256 cellar: :any,                 sonoma:        "fb12cc4effa0a8079048a4c1eaaedc4c6467296d9f9d5666969efbca23e7023c"
    sha256 cellar: :any,                 ventura:       "fba6041decb9cb733ba6384e3e160bbd6b9324c950411b70131d871b1e6c5fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "830f44a8a967924028075ef50675720c79ef42b107d0a45f160745cd96d48ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4b330bc0712739ec629dbbe525bec2d387681baa8e5fac89259f74089561832"
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
