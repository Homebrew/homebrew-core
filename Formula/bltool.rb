class Bltool < Formula
  desc "Tool for command-line interaction with backloggery.com"
  homepage "https://github.com/ToxicFrog/bltool"
  url "https://github.com/ToxicFrog/bltool/releases/download/v0.2.3/bltool-0.2.3.zip"
  sha256 "34f5250ae68a7cec2962d5b6bfc564331d938ecc195bcb690e4e112fefb21510"

  head do
    url "https://github.com/ToxicFrog/bltool.git"
    depends_on "leiningen" => :build
  end

  bottle :unneeded

  def install
    if build.head?
      system "lein", "uberjar"
      bltool_jar = Dir["target/bltool-*-standalone.jar"][0]
    else
      bltool_jar = "bltool.jar"
    end

    libexec.install bltool_jar
    bin.write_jar_script libexec/File.basename(bltool_jar), "bltool"
  end

  test do
    (testpath/"test.edn").write <<-EOS.undent
      [{:id "12527736",
        :name "Assassin's Creed",
        :platform "360",
        :progress "unfinished"}]
    EOS

    system bin/"bltool", "--from", "edn",
                         "--to", "text",
                         "--input", "test.edn",
                         "--output", "test.txt"

    assert_match /12527736\s+360\s+unfinished\s+Assassin/, File.read("test.txt")
  end
end
