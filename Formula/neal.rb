class Neal < Formula
  desc "Analyzes source code based on user-specified rules written in a custom DSL"
  homepage "https://uber.github.io/NEAL/"
  url "https://github.com/uber/NEAL/archive/v0.2.4.tar.gz"
  sha256 "2dc1f2fd2c1cbdbe4914737fcccb6d13d0eabbc67f764d88a3f8c4a1a2bc6416"
  head "https://github.com/uber/NEAL.git"

  bottle do
    sha256 "872dc7f4b7465044534f440bfb8d839f842a3d1698f1b3ef9961a9b420863923" => :high_sierra
    sha256 "6c301172a401cf3394c8fa36e3211c641e42c81137012a92f1929da1a66b679b" => :sierra
    sha256 "c86131f9b343ef599c20dcc39ecc145768a169b2f1d4b8c29725dd3c2466e590" => :el_capitan
  end

  depends_on "camlp4" => :build
  depends_on "ocaml" => :build
  depends_on "ocaml-num" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build

  def install
    opamroot = buildpath/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot

    ENV["OPAMYES"] = "1"
    ENV["NATIVE"] = "1"
    ENV["LIB_PATH"] = lib
    ENV["BIN_PATH"] = bin

    system "opam", "init", "--no-setup"
    system "opam", "install", "ocamlfind"
    system "opam", "install", "--fake", "num"
    system "opam", "config", "exec", "--", "make", "brew"
  end

  test do
    (testpath/"FailingTest.swift").write <<~EOS
      (nil as Int?)!
    EOS

    (testpath/"PassingTest.swift").write <<~EOS
      (nil as Int?)
    EOS

    (testpath/"Swift.rules").write <<~EOS
      rule NoForcedValues {
        Swift::ForcedValueExpression {
          fail("No forced unwrapping allowed")
        }
      }
    EOS

    cmd = "#{bin}/neal --reporter arc -r Swift.rules FailingTest.swift"
    assert_match "No forced unwrapping allowed", shell_output(cmd, 1)
    cmd = "#{bin}/neal --reporter arc -r Swift.rules PassingTest.swift"
    assert_equal "", shell_output(cmd)
  end
end
