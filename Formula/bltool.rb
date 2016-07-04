class Bltool < Formula
  desc "Tool for command-line interaction with backloggery.com"
  homepage "https://github.com/ToxicFrog/bltool"
  url "https://github.com/ToxicFrog/bltool/releases/download/v0.2.2/bltool-0.2.2.zip"
  sha256 "613151a5d86a80f8b2f4a71da3aa93f56649ab19ff1597eed2a96fb43e3cdcd4"

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
