class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.47/nmstate-2.2.47.tar.gz"
  sha256 "48f67d678c8adb3dc003c8b32076d5665bf615f561b13bd967c58e61a4e67775"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0ad54b153008d58cb84763b43c71bb3c9e9b9413dc53238704cf1126178cc61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a65922efa9b6b504fce91e492ee6bfd5d816c85fc52c54d41be07b6e277ad134"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0976940b374214b24c2bd7d58e1ce6b114eb7324bf4440209087aaaf5683afbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c85bd73f1b3cfa7ab2ccb655fd7836609d571ea115b8b59e6cf1229ef42ceac6"
    sha256 cellar: :any_skip_relocation, ventura:       "6811797f15b588c7b1703a61b022daefcbd9f0f11c9c3c3ada7b394b4beaa800"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "535d7becb0650530886bb205f3e398de3a9cc3c12d1b72ce83f150b87e3b2c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9f9cea1d1e6c7bea4a266218ee4a6c1f5cfe60f443c63e997618275f1114017"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
