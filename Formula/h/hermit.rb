class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "b04358caa1f6c33cb8d6f2b53541537057ce249489b5349f327323e8f46ae443"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56af6896578dab347ea1c9900a1e5bf05ebb43e1e7a96451824afb8dab97a291"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bbb7e20d6f44b14fa8779a73968e4e71acf7da5b59680d609a4c5655ce8e11a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ac577b3aa211d420e01ab6f99315d1e8c3c37954f4bdae031a21d37a5bafc92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5df2f4cde90e3348cb0e717d49cd49dbe859e47ac257a35f352f1f3b1f5c1648"
    sha256 cellar: :any_skip_relocation, sonoma:         "7aaf6ce5deae23f8d24e806fddac51259a5663da946f42cf4c3ef3dc7469c86e"
    sha256 cellar: :any_skip_relocation, ventura:        "c05532c6f0116035c0cfc0c32cd6548e288285e5a4e25d6c24275fcdf6ad1946"
    sha256 cellar: :any_skip_relocation, monterey:       "ca5902d555e74350bf82f0599a03510cd65ccc1c7f47e3cda9ab38050aaf04dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d49b6cdb38f7e83a69d5dc730822e8649bd5736e967eeb8d73f1049978fee26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "381f36b84ddaa6b2a7c42cc8adeea632e8ea208c1f31a2f34fbaeae1e1a394f8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_predicate testpath/"bin/hermit.hcl", :exist?
  end
end
