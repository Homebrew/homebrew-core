class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "c99e821710b45d2c2639c1abea45ad9f2d63d3b5b81e19e1fd29604dca05e5e2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e8748befe2d9116fdb60da448121643e9bb49401f9a1e7833343b4ef6fe5d5e3"
    sha256 cellar: :any,                 arm64_sonoma:  "772d39bc35073c662e160ea86d20d153bdd689f360ad7538bd524fddedaa24ee"
    sha256 cellar: :any,                 arm64_ventura: "6e918ed11da60bb72542f68d82e950a54db29f50674de061ec6de5c76267f456"
    sha256 cellar: :any,                 sonoma:        "300b87932cafbc4e4f4bf4576b08cb6aaa89c89fb0cca029f0c55dbb146e05e1"
    sha256 cellar: :any,                 ventura:       "30846356f2db9395c0bb3f4bd07679a0df35d07e8d04e19a76a17b6fc5111d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54272b0971fea5d5d82b27831cad8d4f109ea9db91031ddeb20c47885dfa293a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system bin/"git-workspace", "add", "github", "foo"
    assert_match "provider = \"github\"", File.read("workspace.toml")
    output = shell_output("#{bin}/git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github user/org foo", output

    linkage_with_libgit2 = (bin/"git-workspace").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
