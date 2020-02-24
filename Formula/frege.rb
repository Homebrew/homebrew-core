class Frege < Formula
  desc "Non-strict, functional programming language in the spirit of Haskell"
  homepage "https://github.com/Frege/frege/"
  url "https://github.com/Frege/frege/releases/download/3.24public/frege3.24.405.jar"
  sha256 "f5a6e40d1438a676de85620e3304ada4760878879e02dbb7c723164bd6087fc4"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"frege#{version}.jar", "fregec", "-Xss1m"
  end

  test do
    (testpath/"test.fr").write <<~EOS
      module Hello where

      greeting friend = "Hello, " ++ friend ++ "!"

      main args = do
          println (greeting "World")
    EOS
    system bin/"fregec", "-d", testpath, "test.fr"
    system "#{Formula["openjdk"].bin}/java", "-Xss1m", "-cp", "#{testpath}:#{libexec}/frege#{version}.jar", "Hello"
  end
end
