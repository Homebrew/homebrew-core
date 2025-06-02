class Koji < Formula
  desc "Interactive CLI for creating conventional commits"
  homepage "https://github.com/cococonscious/koji"
  url "https://github.com/cococonscious/koji/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "648b9d47de121895a79e3d963f5fc6e781d82a1531eeec6b3aa91db5951e058a"
  license "MIT"
  head "https://github.com/cococonscious/koji.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6ad589d2ccaf89bbc8e56b42cc1ea81757a914c29447f77f6862ef84f3a5a064"
    sha256 cellar: :any,                 arm64_sonoma:  "5655e3a07a057391e84ed1fbfabc7887d6d37d511581c59e5b9c49b6bff3ec93"
    sha256 cellar: :any,                 arm64_ventura: "9fd26b1e044fb57e2d8ef0d7bbe1ea57aa7ab8b124277bd89adbfc67f7cdd467"
    sha256 cellar: :any,                 sonoma:        "b4b2066c3785fb96b1fc5f280a586a553ba3af079b6536020b4b7ba61073adaa"
    sha256 cellar: :any,                 ventura:       "cdbc54030a73304779b4f7456a7d51bbcfa257cf818043eb63c09171f98f238b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e129ea2ee03bde87de5c0b3f167dd223feacd4815c20bcff21e5e240283b926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3439dfc748254b2ca5f525304e3d329899829bd11a1cfe7593d2a45e38ac4ccd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"koji", "completions")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/koji --version")

    require "pty"
    ENV["TERM"] = "xterm"

    # setup git
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"

    PTY.spawn(bin/"koji") do |r, w, _pid|
      w.puts "feat"
      w.puts "test"
      w.puts "test"
      w.puts "test"
      w.puts "No"
      w.puts "No"
      begin
        output = r.read
        assert_match "Does this change affect any open issues", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"koji", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
