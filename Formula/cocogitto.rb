class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://github.com/cocogitto/cocogitto"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/5.3.0.tar.gz"
  sha256 "c95a8d3d0fd1ca4f122b9e9077e8ff79f1c8a180f2cb5a0afcc6e236495984b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9ad55806a725ea9f144c4be295b0c7af7f3054bc837529c7cf13233833f40f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f427efe2a5656fd7e164db1d226f0346788b24e8fb9f6c01280e0ac0a796ef4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5b24bc4efa1a08c918fc21face5935b1bee4fa598757858b0e74ace7209168d"
    sha256 cellar: :any_skip_relocation, ventura:        "fab6c2e3ba772ba3493ff8e69cd86f2dffb9ce055dfe89f6778b2909c6653c01"
    sha256 cellar: :any_skip_relocation, monterey:       "a0d9114a6296eb274b863f46f1c62fb70abbc35e13542e324cc67b738d4b4211"
    sha256 cellar: :any_skip_relocation, big_sur:        "159aabbb7fcbe2961755c56435f1bee5817e35da1ac54ab2e64e1dd487375ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc3966802fce305d916031c79f61c0ef0353509a6c861c7af5b9ce61d2576d2a"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions", base_name: "cog")
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip
  end
end
