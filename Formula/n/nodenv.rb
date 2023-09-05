class Nodenv < Formula
  desc "Manage multiple NodeJS versions"
  homepage "https://github.com/nodenv/nodenv"
  url "https://github.com/nodenv/nodenv/archive/v1.4.1.tar.gz"
  sha256 "6c6ff198f1b99183431e709f2897774f1e0d5b0dcd105577972f709a61bf80c5"
  license "MIT"
  head "https://github.com/nodenv/nodenv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "47d4c5122eff23675e6ad3f9352b32b5f76e8f7d792e51cdc3975237ecee28f4"
    sha256 cellar: :any,                 arm64_monterey: "ba6861d4f43e60dff19ac5ce379ca7d735b30ec069e82c8adba1481efe1a6ff6"
    sha256 cellar: :any,                 arm64_big_sur:  "455da2a3a195be8acfdcf409527396ea7eecbef7acc4fe2a61302a6da5160d4a"
    sha256 cellar: :any,                 ventura:        "44d883d0e8cb785c10962db06d085be9a973603785bd56f7da0dd48319563ad4"
    sha256 cellar: :any,                 monterey:       "f2f480cc58e07f02797be233a5763fa790784a3a306f5b818af0ee08add55f40"
    sha256 cellar: :any,                 big_sur:        "f1028a5621ac62466cadcd0e5d16c173aaf7b0720021114a943d258b4e141d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b54183dbc56c22fb74e8d0dd0aad919628dc22b4ece6751fe23150afd356df10"
  end

  depends_on "node-build"

  def install
    inreplace "libexec/nodenv" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
    end

    %w[--version hooks versions].each do |cmd|
      inreplace "libexec/nodenv-#{cmd}", "${BASH_SOURCE%/*}", libexec
    end

    # Compile bash extension
    system "src/configure"
    system "make", "-C", "src"

    if build.head?
      # Record exact git revision for `nodenv --version` output
      inreplace "libexec/nodenv---version", /^(version=.+)/,
                                           "\\1--g#{Utils.git_short_head}"
    end

    prefix.install "bin", "completions", "libexec"
  end

  test do
    shell_output("eval \"$(#{bin}/nodenv init -)\" && nodenv --version")
  end
end
