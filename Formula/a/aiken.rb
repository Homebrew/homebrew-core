class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.21.tar.gz"
  sha256 "c6bbdba11a37a6452d6a00c6fee9473264b757475912c4dfd9c3fd18ea60ed4c"
  license "Apache-2.0"
  revision 1
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

  # Backport openssl part 1
  patch do
    url "https://github.com/aiken-lang/aiken/commit/d5aba83a115439384ecd5b4c398c33baf33f7a77.patch?full_index=1"
    sha256 "499e4f309d5a0ea7c047b0d05c8933019d616b6ec831a5dbaf73ebb982c06bf4"
  end

  # Backport openssl 4 support https://github.com/aiken-lang/aiken/pull/1312
  patch do
    url "https://github.com/aiken-lang/aiken/commit/b1756f6311d383c079dfd976c2a2068aedbf922e.patch?full_index=1"
    sha256 "423ed0c5a3453f3870f1984cb67c30806e3f506fbdfe5ddbd7955431858a0cb9"
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
