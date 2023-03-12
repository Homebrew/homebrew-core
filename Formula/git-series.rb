class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 8

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "04889a2a2676538b5529b2cfb5085acce8bb3771b914e1207fb2c4b84a606df8"
    sha256 cellar: :any,                 arm64_monterey: "503c48f0ad4435030aab00b3ebfb1162a49e93bf9332043c66de07c2d8f3a1f1"
    sha256 cellar: :any,                 arm64_big_sur:  "7ee96f2e51fac16a9d1ff0352b74fab9ad68aad0d6c1a4a00e9cd738b03a5fdf"
    sha256 cellar: :any,                 ventura:        "4fdcedd491262fc937cca80829200393fc9323ad126ec3dbab84ed613e8bca35"
    sha256 cellar: :any,                 monterey:       "479c9f19e2ee86d2686ebb106e7d20bca4f71b10b1297544014b6f6f10e2a754"
    sha256 cellar: :any,                 big_sur:        "59dcd3a3cd5044f679d294ba6a4170503f077e601fb6ef7f75f7392ab1dcf7eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3080234f5707f6f8c5cdcde8e93a3cf5e3bbe10b6ea9cc54f1d21a2151f6e0f3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    # TODO: In the next version after 0.9.1, update this command as follows:
    # system "cargo", "install", *std_cargo_args
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "git-series.1"
  end

  # TODO: Add this method to `brew`.
  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS

    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test").append_lines "bar"
    system "git", "commit", "-m", "Second commit", "test"
    system bin/"git-series", "start", "feature"
    system "git", "checkout", "HEAD~1"
    system bin/"git-series", "base", "HEAD"
    system bin/"git-series", "commit", "-a", "-m", "new feature v1"

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@1.1"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"git-series", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
