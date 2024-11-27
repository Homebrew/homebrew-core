class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/4.5.0.tar.gz"
  sha256 "ba5afe509ef17f5cdde8540cfd9321001cbb10d49dd6324f22562d65dbae8738"
  license "Apache-2.0"
  revision 1
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9c1e32de1fb5c0b0519676f8fa0fc580e49e5e6bb38c5fa58f183dc9e8364a82"
    sha256 cellar: :any,                 arm64_sonoma:   "0d109f301a6394c733cd864995e29d6df6bb3b4030486d0550eb55d834d77d1d"
    sha256 cellar: :any,                 arm64_ventura:  "9088a4563e6ceba052130a219e850a586b74675d1a6c294eb5e9495422f4e5ec"
    sha256 cellar: :any,                 arm64_monterey: "f9dd5818d8c8940160aa3764d1f48da7619d15aef6fb85c8c9132f5e2cf8853f"
    sha256 cellar: :any,                 sonoma:         "5d59da37a6aa405fc8d34ca9ada77e3cbaa275aeccecc55c604ee6caebe7854d"
    sha256 cellar: :any,                 ventura:        "168ebebd1ae9754b2e06fa9865d1728cb22da5b07610a467e20951e6e705423b"
    sha256 cellar: :any,                 monterey:       "7b58c51fac765551a1e364f7c78fe87e1a9da6b923c0f974272f24999384eff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3179fe94817048eb453d9d6750cb5eb946ed207277fbce5424e6dade6b6f04af"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"

  uses_from_macos "zlib"

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "bin/gfold")
  end

  test do
    mkdir "test" do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      (Pathname.pwd/"README").write "Testing"
      system "git", "add", "README"
      system "git", "commit", "-m", "init"
    end

    assert_match "\e[0m\e[32mclean\e[0m (master)", shell_output("#{bin}/gfold #{testpath} 2>&1")

    # libgit2 linkage test to avoid using vendored one
    # https://github.com/Homebrew/homebrew-core/pull/125393#issuecomment-1465250076
    linkage_with_libgit2 = (bin/"gfold").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.7"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."

    assert_match "gfold #{version}", shell_output("#{bin}/gfold --version")
  end
end
