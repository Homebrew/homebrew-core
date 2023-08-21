class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "bbee100a10db98adfa2a0913583136d91ceec915a0c7758ec22f1072419fa541"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ee8a2bf71ef064983d5aeb7548bc731f83eaf77986a9b20850cafe82eaafed2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e20cc2679a1936d2a555478cfdc222c6c361faf4a24dc001b8b6f2ad6bbbb416"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a16b337a37293a1f26fa30ea689e6f94b4113e6950781f9b4167ca24b4183471"
    sha256 cellar: :any_skip_relocation, ventura:        "40a9f70415415f9ba51681f34502ab65b29fb35f4882091f13648bba99335fcc"
    sha256 cellar: :any_skip_relocation, monterey:       "73fcb427e230a6eca27987c8430fd55bf392fd20ae2aa978ed3a07c1a85eed21"
    sha256 cellar: :any_skip_relocation, big_sur:        "2af48db266a0021cbdc8150e5041f35eedfa34c11aef15ca36d8cf4f24ebbda2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b736ffa84c5b8628c8c4a35f6686a4a3409b00d3078f818daafeb538ad9b5d1b"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "target/completions/convco.bash" => "convco"
    zsh_completion.install  "target/completions/_convco" => "_convco"
    fish_completion.install "target/completions/convco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(/FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n/,
      shell_output("#{bin}/convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    linkage_with_libgit2 = (bin/"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
