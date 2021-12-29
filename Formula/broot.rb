class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.8.1.tar.gz"
  sha256 "c806130c4982b064ccaa7fec79436af71d4cf06ace33c2cb34d4d30b3c1095e7"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efc10bc9c9b22177eda9776752590c801c5f7beca04b26c1a3787367f07b2aca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c735e13faa0a4b84376eb5ef324174107fdf274c0933228ec595fda1191f4110"
    sha256 cellar: :any_skip_relocation, monterey:       "22ad0ffb10d3a443d3a2e86dc86adf243a3177f4fd3668c8f9194fcfa9aad86e"
    sha256 cellar: :any_skip_relocation, big_sur:        "54ad30e882b1d32c698478ea8bc3d07d3cc337d58d031f1a84aaf87621a14f13"
    sha256 cellar: :any_skip_relocation, catalina:       "aa5b8d6f7fc6f2648a0ce67b8ef62a0523004c04fc0140b4d3a43dfd751aba8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f3b131dd944544e02df2b17f0caa0dc1c8145f23b54adbc4f3350d4d08eecf"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
  end

  test do
    on_linux do
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--color", "no", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
