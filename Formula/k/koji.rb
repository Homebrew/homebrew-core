class Koji < Formula
  desc "Interactive CLI for creating conventional commits"
  homepage "https://github.com/cococonscious/koji"
  url "https://github.com/cococonscious/koji/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "fe3a56bc7f0829d434b82d8bda51c6cae7dbc909a1ae7980b31c63338349af73"
  license "MIT"
  head "https://github.com/cococonscious/koji.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "041e6a96f3dbf36efba528dd6380ddf39d8ec45221850a0224d7d0c600b9309f"
    sha256 cellar: :any,                 arm64_sequoia: "e58c28eaab0ce31ae0d7bf7d994d061020a149825a61af7771f7acdb4bc602cd"
    sha256 cellar: :any,                 arm64_sonoma:  "5445f0447d2c0505a49e4efe156f9030816fdf61341195434f7ad304b24ad92e"
    sha256 cellar: :any,                 sonoma:        "2e2ad1bb4bf6c1436723a1535e6a581d24352efc62ac64b31d178f78f3f1bd15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc21512132d4d6fade55d249fb114486e52da4e0f433edc948caea55bb5aaa4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fef9220c1c6293ed5c896fad2fe69740749a87e66255a2d778fb4053b34c5b27"
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
