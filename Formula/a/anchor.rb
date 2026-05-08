class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/solana-foundation/anchor/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "e07f8e8aa27f732d9609b250a7ec0111237acadd2fa0cf3c1fc9ae7e36046b3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f184694cd6aad2d8758e9d923fbd1262cfbc9e2be807fad05666d3b09f8742d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b35fcd799d7572de0a77e84b4bec572189d31ccb14880629ff3b5bcb2b44e455"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43c36988c81f0d4501b66fc0dee97a17ca8c01f426ab63bcadf16f40ff76b1bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "33231afe19d51339af4538bbc90f9a7760bd80b487f69d5fbfaf278a82cd688c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7422510a335c89d2464cffc48c5e6ec4f01ac9991ae5dd84ff03685c382e565b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95aa0429fe630cce43209f9c597945d4a3b48a9516c773407882d9c81fee420"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "node" => :test
  depends_on "yarn" => :test

  on_linux do
    depends_on "systemd" # for `libudev`
  end

  def install
    # FIXME: "Unknown attribute kind (102) (Producer: 'LLVM21.1.8' Reader: 'LLVM APPLE_1_1600.0.26.6_0')"
    inreplace "Cargo.toml", "lto = true", "lto = false"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"anchor", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "anchor-cli #{version}", shell_output("#{bin}/anchor --version")
    system bin/"anchor", "init", "test_project"
    assert_path_exists testpath/"test_project/Cargo.toml"
    assert_path_exists testpath/"test_project/Anchor.toml"
  end
end
