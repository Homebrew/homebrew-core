class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/3.1.4.tar.gz"
  sha256 "a13e7686438f30a7fd6f29205768d68eed6db28fc227346ebdc941582eb3699d"
  license "MIT"
  version_scheme 1
  # TODO: Uncomment when default branch is changed from 'master' to 'main'
  # head "https://github.com/go-nv/goenv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87fc705a39945ba20439bd9a8df79394fe3188e79dbccee689375a5b7b2c2f15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87fc705a39945ba20439bd9a8df79394fe3188e79dbccee689375a5b7b2c2f15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87fc705a39945ba20439bd9a8df79394fe3188e79dbccee689375a5b7b2c2f15"
    sha256 cellar: :any_skip_relocation, sonoma:        "48f4e314e23b886b0a95d92c56729b3f378ba76ad6253c951ea4075eb4e4cf54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a987a55c19053288c9cb2cbd69706407259b110c9224dcf285eaaf38e23b2c0c"
    sha256 cellar: :any,                 x86_64_linux:  "ebd1c07f8c49e8a225cdee7d32964311d6713b8a15f2bf310f22e70e7f256af4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap&.user || "homebrew"}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"goenv")
  end

  def caveats
    <<~EOS
      If you are upgrading from goenv v2, you may need to remove the stale shim:
        rm -f "${GOENV_ROOT:-$HOME/.goenv}/shims/goenv"
    EOS
  end

  test do
    ENV["GOENV_ROOT"] = testpath/".goenv"

    output = shell_output("#{bin}/goenv root")
    assert_equal testpath/".goenv", Pathname(output.chomp)
  end
end
