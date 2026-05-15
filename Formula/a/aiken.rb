class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.22.tar.gz"
  sha256 "c0b40b4c6ec79f06fc6f860fefa4372eb0d2190f34ed9243f9140e351598911a"
  license "Apache-2.0"
  head "https://github.com/aiken-lang/aiken.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1880676384c217aebfa1835c94df19fa25a9f30049c1259a037d68d0e532c82e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd5de1d90c2b519dc31172a78c2561b0ff231089d2c6059ff5cb4cb1ac149fc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b094e38d7c67bde13386ad4b32f2242dd15cf1f611d5867fc39881ba80b36631"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bfc0c056f9d7d513c0df13b2ef087130a5d931cfad9ac39fc82489ed996bb45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca34ae5907f8efe7affd7e3170ea1a4cf8d926cb010c216d217e217175396946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee3811ce4cac5efefda4a264ffe65fbf7631bac3ef59aa4cb25aef84525daee"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aiken")

    generate_completions_from_executable(bin/"aiken", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aiken --version")

    system bin/"aiken", "new", "brewtest/hello"
    assert_path_exists testpath/"hello/README.md"
    assert_match "brewtest/hello", (testpath/"hello/aiken.toml").read
  end
end
