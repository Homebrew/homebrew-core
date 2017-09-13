class Frege < Formula
  desc "Non-strict, functional programming language in the spirit of Haskell"
  homepage "https://github.com/Frege/frege/"
  url "https://github.com/Frege/frege/releases/download/3.23.288/frege3.23.888-g4e22ab6.jar"
  version "3.23.888-g4e22ab6"
  sha256 "b825fbdccb5c3e81ef36f51b112d2dc449966dc5f11578a89b93e39bcac2f695"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"frege#{version}.jar", "fregec", "-Xss1m"
  end

  test do
    (testpath/"test.fr").write <<-EOS
      module Hello where

      greeting friend = "Hello, " ++ friend ++ "!"

      main args = do
          println (greeting "World")
    EOS
    system bin/"fregec", "-d", testpath, "test.fr"
    system "java", "-Xss1m", "-cp", "#{testpath}:#{libexec}/frege#{version}.jar", "Hello"
  end
end
