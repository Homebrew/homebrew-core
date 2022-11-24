class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.25.0.tar.gz"
  sha256 "b575a400cc81cc15220cfaadb5cdf3f3f727193e7c9986403fd1724ddca5d6d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dfb079dd0ebec48df244cc58175e8314c018904dff61bd4cacb586d0ac8b561"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c098f9a6e62bf9df40382bf842f490ec087e5e324fa11c5d6d9ff5a717364d5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "288fcfb661086f8337f24c8992fe68c516987e17f902a1f715d58ecc09c26f42"
    sha256 cellar: :any_skip_relocation, monterey:       "fc487ba7bac36726ac2159076c1e82fa856f0871df08d3643f66cbe002ab543d"
    sha256 cellar: :any_skip_relocation, big_sur:        "85ea52a6f5d0ab79431b3a2f214fc1240ab7574bf72335ee3e9d7a7c2c222c84"
    sha256 cellar: :any_skip_relocation, catalina:       "09943146c51cbd598bd51baee6c4ea873fef62762df3f66cf5b5a4f2656eeb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f529084f2c14d44675c2c7df5269f575e3d80e65e9bca5778810bc3b6e1a7dd2"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "gleam", "test"
  end
end
