class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https://github.com/nickgerace/gfold"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/nickgerace/gfold/archive/refs/tags/4.4.0.tar.gz"
  sha256 "d1f8c5a578bc20751a8584c73d4df3092364b0616226656d71dbf954edd481c3"
  license "Apache-2.0"
  revision 1
  head "https://github.com/nickgerace/gfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8b4997231ab3ed1680bf1411f5b50542ad22cba63458759700cb193c4378375"
    sha256 cellar: :any,                 arm64_ventura:  "2c3202011e9ed676192d573292428cc2f96b6b93d8584b32f5c9902afc91835c"
    sha256 cellar: :any,                 arm64_monterey: "6bf31918b5130dd9b20c50e1aa0d1ce30eb4e7360d24246568edf1d1ce327d0f"
    sha256 cellar: :any,                 arm64_big_sur:  "b8575070e071d18fb85d33996f652dd41332efe4de74c39bff9eb31d613cd3a6"
    sha256 cellar: :any,                 sonoma:         "445893f4ab6386a49958dd0f64d115e9152716297f691836dd07c1a6e2f2deaf"
    sha256 cellar: :any,                 ventura:        "e331f58eb2250adeefc2a2c725963e27c7fb4cd18089141c02f5863bcb27d767"
    sha256 cellar: :any,                 monterey:       "7c85c66db643ee79188c3ba810f0995750f366bd6fb2252a2df2297dab666bc4"
    sha256 cellar: :any,                 big_sur:        "a187356fa10c4af5116a9ceebae7f1bc09bef032b7b5c1c2eaebfab3bccfe8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9607d24633b3b73369142d66ca0dba4c10c41f41e2f30cf5153e5e329c1e3ba"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/nickgerace/gfold/blob/#{version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Migrate to the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"

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

      File.realpath(dll) == (Formula["libgit2@1.6"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."

    assert_match "gfold #{version}", shell_output("#{bin}/gfold --version")
  end
end
