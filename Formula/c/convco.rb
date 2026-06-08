class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "907a7db94f0f49c2ee547c0aebfff50500a9d886a7e575bc0288d6937101972b"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f4a0969e3b60c01c5fcc1dceefa0b7544f80d73c2374bba526b5953e7360069c"
    sha256 cellar: :any,                 arm64_sequoia: "08a739ef2b32e8dd522246aa3ecd6b293cbde33cc82ddded91262c9a9670560f"
    sha256 cellar: :any,                 arm64_sonoma:  "cb8eb3d9475713310a35b1602ae42a89021e11c6f0bf6e77334887d08c13cfe2"
    sha256 cellar: :any,                 sonoma:        "6ff6540112f11725e5607b1dedeb254ead9001bbf43708468ee87c75edb995e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e8aeb9afaeee368d3dd271b6e60abd205568586f6d134d9f0a9f5c75f70fd61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "685ab707d227454b95c081fa542636997400a46160af144019e411fafc15cc36"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

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
    require "utils/linkage"
    library = Formula["libgit2"].opt_lib/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"convco", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
