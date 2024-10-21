class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "ed68341e065f76f22b6d93ff3686836a812f6a031dc7ee00bed7e048b0da4294"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e18c04a894c906be8f793678c6eeb79b471253036813a154c4531dc791b941b9"
    sha256 cellar: :any,                 arm64_sonoma:  "6f3676b484578a35386192edf44e82e2ce028befef87ad40b5b6d6b89995425e"
    sha256 cellar: :any,                 arm64_ventura: "963b46df26ac69066af13e1cbec5672a6d8005363053e474f099101484b98352"
    sha256 cellar: :any,                 sonoma:        "05bf86ff418758f4c82fb9e1d931f1f58804c21e35807c79dea4c63127056d76"
    sha256 cellar: :any,                 ventura:       "ecf3ab426b73d4519e34d2cdd50d070ff8074e3ce2b4131a242a784349504a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e0109d8ad3f830c0307d2350f190ef1afad564ac1af83120cc5fb72e3d41114"
  end

  depends_on "pkg-config" => :build
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
    linkage_with_libgit2 = (bin/"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
