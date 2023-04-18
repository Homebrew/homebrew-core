class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f0c466c52a6c4f1e160195c07d2769e397b5c430a7e099c5e83957d15560c5f"
    sha256 cellar: :any,                 arm64_monterey: "8a369876e7020187f64383c5648bee3999fda97fec7fea4337005effb1aedecb"
    sha256 cellar: :any,                 arm64_big_sur:  "86da0b8d651dd3ed067c07ab62d764604c037a793d245b46704fd99321021bb8"
    sha256 cellar: :any,                 ventura:        "60c8902fd153b2ac7e406e33ba04a734e63cbaf2161fa5e8711a85a27c8063d9"
    sha256 cellar: :any,                 monterey:       "dda19762e1ee0a3e08c9480afd6e5dd546f59ebc40a3661b7af6635d8061b07b"
    sha256 cellar: :any,                 big_sur:        "8fb717cef8354558eb6513a323240db699bf885b8931bdb5b1ca38b8793fafd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72e716f079406bd81c575e9d122ae6a940240848a69e5a02a9539f78a744adc7"
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
