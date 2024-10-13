class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "73329fe24c53f0ca47cd0939256ca5c4644742cb7c14cf4114c8c9871336d342"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9d17cfb029fbdc6ed31c732108f7aa746d3082dd4783ed35471ef79340615509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82d5c2ffc2e2d0d8643a7c3f620c81ed49d7b23920aa23b6a7f4c50be69abc0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "354412ababb7d6c52abd9153ff96f133391406ce292b2122c76b96c2ab714f87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b41f292041767fd1c3c5b92daaa6c823fb07c1d7cd11b0427a415f08463f035"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fa0fb4b3f512e45d35c569953efc7c59ebd8976caac9b2c1b1394b7e29157a0"
    sha256 cellar: :any_skip_relocation, ventura:        "b1406e5414252b1e1b90cfad188454eb31058256ed6246baed48c4e1cfe593a1"
    sha256 cellar: :any_skip_relocation, monterey:       "0ac060bf7d1529aa1f65e634f64b98b906df533d71f2185c883165c01f59ad53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2464fb21cc981166ffa9783fa14a09265790af4d89ce3a763421ddaf29119541"
  end

  depends_on "rust" => :build

  conflicts_with "fdclone", because: "both install `fd` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish])
    zsh_completion.install "contrib/completion/_fd"
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https://github.com/clap-rs/clap/issues/5190
    (share/"bash-completion/completions").install bash_completion.children
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
