class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "f4dc3eec0f7f6b902073ff5ae559945a32ea4af0ec8b3513527e9cca2fea7b9b"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b957a8826c1e40cd5a9e15639b552a4e99d35d6f0560b2e051904d4864a89dc"
    sha256 cellar: :any,                 arm64_ventura:  "8ed3e11ead2ef3b66418e00d6bf364204b5558ed7c420e77caf6ce04cb61b494"
    sha256 cellar: :any,                 arm64_monterey: "5b5341b389bc731a89d8ec65830ebb7bb18ac96e3c7e7669ffd0cb9540fbb025"
    sha256 cellar: :any,                 sonoma:         "62757f35e6d047eb3b6fd0a4c502454c69d0a142d0c12790f7e62b40dfba8d51"
    sha256 cellar: :any,                 ventura:        "01a7f95c788f1259348b0430afb3171978e126bb6cf403521ddb49c4b6046ee8"
    sha256 cellar: :any,                 monterey:       "fc909b0a96f3146a339aedc3a2b8f195d6bff93694f387397a0eb9de69489906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0a65d968ea3cd4c70f782bc2c396a461548d8e5b17cfa525dac83d76841235d"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"jj", "util", "completion", shell_parameter_format: :flag)
    (man1/"jj.1").write Utils.safe_popen_read(bin/"jj", "util", "mangen")
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end
