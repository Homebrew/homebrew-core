class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://github.com/ignite/cli"
  url "https://github.com/ignite/cli/archive/refs/tags/v28.6.1.tar.gz"
  sha256 "71f3cb80ee9be74ec95ce7ba1cc618b0e929719d442051a711f6f3bd5c897bf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc3c70aa271ce6d197e1c48e3de8fc833f08a375b3b0b596707a343887547a9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca7ea17b2b5bb452f113ee93e7309406ed49139f822303360d022ca220841d89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b983a49f14586c2e6d8ecb3cd0c35df1b5aac376aa1ff58253fb867f8150d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "168079095bf2df0ffe954301cad71cffba58280095ed523f871d322a9f7056c1"
    sha256 cellar: :any_skip_relocation, ventura:       "f9a44a7b95b605afd485113d68cdea80ad7fbbffe3a9e9be3081b1387444252f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a39b7f3dba931cb537169d903b443e8482b231795dfbf7a34a58071a78c1dd"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"

    generate_completions_from_executable(bin/"ignite", "completion")
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    assert_predicate testpath/"mars/go.mod", :exist?
  end
end
