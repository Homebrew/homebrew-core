class Nodenv < Formula
  desc "Node.js version manager"
  homepage "https://github.com/nodenv/nodenv"
  url "https://github.com/nodenv/nodenv/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "4351a5fc642461d3bc92cf5228a558bf421e05c722b8827961d7f3a0e1cb5b50"
  license "MIT"
  head "https://github.com/nodenv/nodenv.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c55d5fa041bff0f7c662111988bb1b67f78ccf8e6caab9f77d7088c6445db44d"
  end

  depends_on "node" => :test

  depends_on "node-build"

  def install
    # Build an `:all` bottle.
    inreplace "libexec/nodenv", "/usr/local", HOMEBREW_PREFIX

    if build.head?
      # Record exact git revision for `nodenv --version` output
      inreplace "libexec/nodenv---version", /^(version=.+)/,
                                           "\\1--g#{Utils.git_short_head}"
    end

    prefix.install ["bin", "libexec", "nodenv.d"]
    bash_completion.install "completions/nodenv.bash"
    zsh_completion.install "completions/_nodenv"
    man1.install "share/man/man1/nodenv.1"
  end

  test do
    # Create a fake node version and executable.
    nodenv_root = Pathname(shell_output("#{bin}/nodenv root").strip)
    node_bin = nodenv_root/"versions/1.2.3/bin"
    foo_script = node_bin/"foo"
    foo_script.write "echo hello"
    chmod "+x", foo_script

    # Test versions. The second `nodenv` call is a shell function; do not add a `bin` prefix.
    versions = shell_output("eval \"$(#{bin}/nodenv init -)\" && nodenv versions").split("\n")
    assert_equal 2, versions.length
    assert_match(/\* system/, versions[0])
    assert_equal("  1.2.3", versions[1])

    # Test rehash.
    system bin/"nodenv", "rehash"
    refute_match "Cellar", (nodenv_root/"shims/foo").read
    # The second `nodenv` call is a shell function; do not add a `bin` prefix.
    assert_equal "hello", shell_output("eval \"$(#{bin}/nodenv init -)\" && nodenv shell 1.2.3 && foo").chomp
  end
end
