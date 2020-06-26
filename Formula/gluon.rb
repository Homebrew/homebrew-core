class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https://gluon-lang.org"
  url "https://github.com/gluon-lang/gluon/archive/v0.15.1.tar.gz"
  sha256 "9e05b157337804a4cf111ee8a1854250970c460e9a32d3b662fc90ebf5b91638"
  head "https://github.com/gluon-lang/gluon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c81ab3772a8ec0e0d0fcc6a0566f0a031ee949bd7703480b9981e8ace0f33028" => :catalina
    sha256 "b601ddc20dc2e67702ff2fccd9750393c77a3d121d3e25366909ef30370136cd" => :mojave
    sha256 "3e806c404ad175fe37f1ad13c7ce6e229a3654b61ccb70e0ff814e1fbe628222" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cd "repl" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.glu").write <<~EOS
      let io = import! std.io
      io.print "Hello world!\\n"
    EOS
    assert_equal "Hello world!\n", shell_output("#{bin}/gluon test.glu")
  end
end
