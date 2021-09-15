class Bltool < Formula
  desc "Tool for command-line interaction with backloggery.com"
  homepage "https://github.com/ToxicFrog/bltool"
  url "https://github.com/ToxicFrog/bltool/releases/download/v0.2.4/bltool-0.2.4.zip"
  sha256 "5bef751aac7140f8a705b29edd35a7bfa9f87c36039d84d4001f16a307b64ef6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7e39e99cb80f5e3c028ef7199c54fd4e0bfe5098fe416f1b74482213fbd8651"
  end

  head do
    url "https://github.com/ToxicFrog/bltool.git"
    depends_on "leiningen" => :build
  end

  depends_on "openjdk"

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
    (testpath/"test.edn").write <<~EOS
      [{:id "12527736",
        :name "Assassin's Creed",
        :platform "360",
        :progress "unfinished"}]
    EOS

    system bin/"bltool", "--from", "edn",
                         "--to", "text",
                         "--input", "test.edn",
                         "--output", "test.txt"

    assert_match(/12527736\s+360\s+unfinished\s+Assassin/, File.read("test.txt"))
  end
end
