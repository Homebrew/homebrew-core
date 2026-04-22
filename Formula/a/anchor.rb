class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/solana-foundation/anchor/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "ae90370749897dba0b7ab26d8ab4c7c18648c45eadb6da92cdedc8bd6f257294"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "097566ad2a2361ffea78dfa7c5f5c9fa889bea5cb832eb8f38e04397bef4643b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "783456c49994cde7cd3e47c348e68cb760efb391eda6864a9a0008376bfec98a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d7092b29b9d2758aa77eaf7c55dbfd23ee35ca41548ec952808edcceb67ded0"
    sha256 cellar: :any_skip_relocation, sonoma:        "50319f6d8d34f6fbd0265b6c60d34f53cf4d126b1294cf0f5f2dd5cd39078e48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "919a112947abec5a42174e605f531cf77aa1539c28f2f5aa21a7b640e7e778d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654e329ee1061587040f01847895eec58cf1e8935213945fad161f1ed166b8fa"
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
