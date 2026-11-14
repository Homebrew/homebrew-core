class GooseLang < Formula
  desc "Systems programming language with flat, pointer-free data structures"
  homepage "https://aardappel.github.io/goose/"
  url "https://github.com/aardappel/goose/archive/refs/tags/v2026.4.tar.gz"
  sha256 "943d785fb191de7b52539e9cf16715701babcacd339323f786729c2132343d9b"
  license all_of: ["Apache-2.0", "LGPL-2.0-or-later"]
  head "https://github.com/aardappel/goose.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "28a9e5fee8c539aa2c7737ccfce3f5d3dac632f45a05665b3d2868fa975a28f9"
    sha256 arm64_tahoe:       "54a2bb55837e0e800801836da97109175855e94e4dc7e5e71dc838d3bd3f429e"
    sha256 arm64_sequoia:     "c3ab0cae845f314248cd6116f5ad49d52f9b13c5032a4ea7cd8e3b6083b17215"
    sha256 arm64_linux:       "af6715deb202646c6e0fdaefc85526ba66270809b430fa6992d176a2b02082b7"
    sha256 x86_64_linux:      "f3c32cd23fd97a2f097318aa18006542fa9bd0fe65c1357d1a47352f5ec89290"
  end

  depends_on "cmake" => :build

  # TODO: add `conflicts_with "goose", "block-goose-cli", because: "both install `goose` binaries"`

  deny_network_access!

  def install
    # The compiler looks beside its own binary first, then at these paths instead of the build tree.
    args = %W[
      -DGOOSE_VERSION=v#{version}
      -DGOOSE_STDLIB_PATH=#{pkgshare}/stdlib
      -DGOOSE_TCC_LIB_PATH=#{libexec}/tcclib
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"

    bin.install "build/goose"
    libexec.install "build/tcclib"
    pkgshare.install "stdlib", "samples"
    doc.install Dir["docs/*.md"]

    (man1/"goose.1").write Utils.safe_popen_read(bin/"goose", "help", "--man")
    generate_completions_from_executable(bin/"goose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose version")

    (testpath/"hello.goose").write <<~GOOSE
      fn square(x: i64) -> i64 { return x * x; }

      fn main() {
          var t = 0;
          for x in [1, 2, 3, 4] { t += square(x); }
          print("hello goose ", t);
      }
    GOOSE
    assert_equal "hello goose 30", shell_output("#{bin}/goose hello.goose").strip
  end
end
