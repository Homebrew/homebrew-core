class Dura < Formula
  desc "Backs up your work automatically via Git commits"
  homepage "https://github.com/tkellogg/dura"
  url "https://github.com/tkellogg/dura/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6486afa167cc2c9b6b6646b9a3cb36e76c1a55e986f280607c8933a045d58cca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "40c2ba7c1f7508541cdd088254e4c15281f14a42cf90dd9b98a710b5aba98726"
    sha256 cellar: :any,                 arm64_big_sur:  "9731db27ddb23fde6069bc6490ca35cc436cc00412e35baad78cfeb70699eecb"
    sha256 cellar: :any,                 monterey:       "7b2c26450f55264e571035d9024a704a75adcb6f6f9aa46081632013d8d41e55"
    sha256 cellar: :any,                 big_sur:        "75fb340dd6b2e913f0d650154007b77fc36ef4e9d0fdcb37f1838d88820c0a1a"
    sha256 cellar: :any,                 catalina:       "26815dddc7135bf029e0d97d3c91f33489c390635153a73528be3df1405079bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8911a6d54186e122eaca20078a568745ce1cd4d8c92449eb2198f4d97593592"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"dura", "serve"]
    keep_alive true
    error_log_path var/"log/dura.stderr.log"
    log_path var/"log/dura.log.json"
    working_dir var
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    assert_match(/commit_hash:\s+\h{40}/, shell_output("#{bin}/dura capture ."))
  end
end
