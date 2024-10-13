class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/refs/tags/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "07cdafe7f171d1aac9404902f0d201721c7dbda7bb75919091912e327994b682"
    sha256 cellar: :any,                 arm64_sonoma:   "524192ede385b910c7a60b441a37eb2c38e6b8cc0520c46a97242264040601a1"
    sha256 cellar: :any,                 arm64_ventura:  "534069e9ffcbf292060e4ef30fca7c1379314d5bcd43a413ce8f2ac793058abe"
    sha256 cellar: :any,                 arm64_monterey: "57110db5cd6e45abc2512b7481fb0058a6735efef1b1aa8620afbd218ad8ffc9"
    sha256 cellar: :any,                 sonoma:         "59b9057f0c273441d3f85045a13cd5cfcfe05b4064875959239d7f1ab86d7839"
    sha256 cellar: :any,                 ventura:        "a5f09b69f4d6a3f3042ee2958150260228e286681c5a0fe770c78e298e9f8928"
    sha256 cellar: :any,                 monterey:       "f6854b262b06eec4237f8ed177e2e2b492604ba92db05c0d43fe94070a1c791e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e30b3ca3b0d4459f63857d9f6979b0976db69777671b37d29e1c9118817ff5"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
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
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"git-series", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
