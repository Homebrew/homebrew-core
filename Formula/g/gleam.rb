class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "34dfdc397835849bc56ac01bf45e68ee9cfc3c99609fb7b3ab02910930a8c40d"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4672bd93a1564e16658b71e7a1597e2ecd36f64ba010313060b0c2b0a2e6345b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79f885035c083d23f6ccc833790db330bf5dc483f498cd107df3c3775f90aa73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60c2bc58545d7ebf9d571361105bdf0027ca82bd530ea194be3915343a4c57cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "762844129b1b37222b5ad4e2cd77b126e25f8f7fc0eb7330c053a612c787ef37"
    sha256 cellar: :any_skip_relocation, ventura:       "1f318d60c97f77d74d08bee529d478ca6b2aae08a6a42ab75b77802b496baf37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "820490880769cd092bd5b53d2cc72f76c42433caef13a5c09bff7328e30d0040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8654349efaf3e850b5eafa95f685f9cfd35151e25f27cfea37f8e40593c11661"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
