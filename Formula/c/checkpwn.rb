class Checkpwn < Formula
  desc "Check Have I Been Pwned and see if it's time for you to change passwords"
  homepage "https://github.com/brycx/checkpwn"
  url "https://static.crates.io/crates/checkpwn/checkpwn-0.6.4.crate"
  sha256 "3cd332d710423463b159cc5e3e0af42d4d498e0d36eda3bae9e8c3c18fb11d44"
  license "MIT"
  head "https://github.com/brycx/checkpwn.git", branch: "master"

  bottle do
    manifest_sha256 "271ff7bac59fa957b43723215a6d6c5be5823d831d948d09c35673da8cf9b35a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bcffcb46396526499677515dc7d7de1c76ec7612f8c031c4f4c73acf668ff96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db00354c907dae8adb8e44f6ecfc7a0cfd161a02955fb88ddab72ee71c5a0b1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03aa4b28a66b2c9868f5f93c861af8e687fdee26b5d466a198fbbf63f0772901"
    sha256 cellar: :any,                 arm64_linux:       "708bc118f65c085b5ce79f8739149513455ece0dca8d7e3da7d336e8efa72cee"
    sha256 cellar: :any,                 x86_64_linux:      "50f5f3fd6051d8d0140df890ea66c48cea953ff2d07800ad32f1d18f4905d5d0"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/checkpwn acc test@example.com 2>&1", 101)
    assert_match "Failed to read or parse the configuration file 'checkpwn.yml'", output
  end
end
