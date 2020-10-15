class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.11.2.tar.gz"
  sha256 "3f308915fac58876aeae39cedfbdb44dd7775567ace36ff3b83ddb4ea1498ce0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6341cb125abf33b142c33104b89d6ad680ae7e2fb9cc15e20984a19466d2de6b" => :catalina
    sha256 "ccfb7ad2cc98c358ce6f2ac4797e3d2cb60683c36420419d57a257d63f5fe907" => :mojave
    sha256 "f8a8090c533509c5449fe24ee49da9cb4da2f18cda095cd48a487c9861803e42" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
