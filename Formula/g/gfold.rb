class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  url "https://github.com/nickgerace/gfold/archive/refs/tags/4.4.0.tar.gz"
  sha256 "d1f8c5a578bc20751a8584c73d4df3092364b0616226656d71dbf954edd481c3"
  license "Apache-2.0"
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "387c3b56addb62d66d5b4a90fd4f9c5a810b0410ff4968db25ce6dc918d16dac"
    sha256 cellar: :any,                 arm64_monterey: "b10b2cc728ebaba127538a8c6c32cf6735cd1c464305c8bfb68bc12554188683"
    sha256 cellar: :any,                 arm64_big_sur:  "f458032d5fbfc31ade19cc9a5c633268ba5bdbb1376d11ccd816d8b99685da96"
    sha256 cellar: :any,                 ventura:        "808d959ef6219ac17f0005f8264fb1c0ec49401d63a74cefe200772937549fde"
    sha256 cellar: :any,                 monterey:       "f0dfc994e3c2148775dcf20e02b93a0d23cb9e636e726fb56241d536f388e8e6"
    sha256 cellar: :any,                 big_sur:        "68d48c0c4cd08ecd3c0fc79614664e682234d5dea6a7920e1fe8f116b0d9c823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f12c02b19246e2a783c112ec1f95da175df5c226f31c874a3a3bdf4321fac984"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"

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

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."

    assert_match "gfold #{version}", shell_output("#{bin}/gfold --version")
  end
end
