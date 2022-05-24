class Frege < Formula
  desc "Non-strict, functional programming language in the spirit of Haskell"
  homepage "https://github.com/Frege/frege/"
  url "https://github.com/Frege/frege/releases/download/3.24public/frege3.24.405.jar"
  sha256 "f5a6e40d1438a676de85620e3304ada4760878879e02dbb7c723164bd6087fc4"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?frege[._-]?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "28f3c0d702b145adb8d615507d492ce37bf7309fde2dcda48b47397c2a387ffa"
  end

  depends_on "openjdk"

  def install
    libexec.install "frege#{version}.jar"
    bin.write_jar_script libexec/"frege#{version}.jar", "fregec"
  end

  test do
    (testpath/"test.fr").write <<~EOS
      module Hello where

      greeting friend = "Hello, " ++ friend ++ "!"

      main args = do
          println (greeting "World")
    EOS
    system bin/"fregec", "-d", testpath, "test.fr"
    output = shell_output "#{Formula["openjdk"].bin}/java -Xss1m -cp #{testpath}:#{libexec}/frege#{version}.jar Hello"
    assert_equal "Hello, World!\n", output
  end
end
