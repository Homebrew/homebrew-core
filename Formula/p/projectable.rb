class Projectable < Formula
  desc "TUI file manager built for projects"
  homepage "https://dzfrias.dev/blog/projectable"
  url "https://github.com/dzfrias/projectable/archive/refs/tags/1.3.2.tar.gz"
  sha256 "8677aa186b50e28ae1addaa9178b65de9e07b3fcd54056fd92464b49c9f71312"
  license "MIT"
  head "https://github.com/dzfrias/projectable.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b1841396e1fbe48ea92b634be22e4c1f15356fda280eacb4cadf3c5795c29cbe"
    sha256 cellar: :any,                 arm64_sequoia: "f355d14b2034c1fb76bf40a0ac128cb5676f234169393a61de59ae51e77da776"
    sha256 cellar: :any,                 arm64_sonoma:  "0eafa10a8ae0d7b2a90f70145efb71a517609fa31e09ee10b7fe734201965f0c"
    sha256 cellar: :any,                 arm64_ventura: "a288dcbf708ffeb16c512655d9426e801553471fee1c095a6d2d329f41ccb6ec"
    sha256 cellar: :any,                 sonoma:        "69ff855f70534030139cdda5c4097aa271b15d3d1a0fb0f12455fa6c1e35e94a"
    sha256 cellar: :any,                 ventura:       "9e4c0a031c0e5a51107f68cceaa6840ef7a39fbcd434d1ec04b80a8b891a2cc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94f11e18c380dbb5abb93f6d4869b17e28703cec992939d30e86f9c2583f7683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "136b8c39fe40e6103870b2b193562107b86302613337bce7892b24dcb2007515"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    system bin/"prj", "--version"

    # Fails in Linux CI with "No such device or address (os error 6)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"prj", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "output.log", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"prj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
