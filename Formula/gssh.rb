class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.9.0.tar.gz"
  sha256 "9199c675b91041858a246eee156c6ed0d65d153efafb62820f66d3722b9d17bf"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c408d17013e20ad9b24e049c860fb9e50eb174bc94d9ad6294f4d9c481c7af66" => :mojave
    sha256 "311d623eacb369d6c207e850d74468e782a6c9c098cc25a6ca7292c3b5c9110d" => :high_sierra
    sha256 "fa84c67a395acf4a4fca8d68f053dbc403782469ed01b21e466e897d234c03d4" => :sierra
    sha256 "37b7c923ea68f2b7e515f9fe865b7e81f2662999c3f030a69627518ee99d611a" => :el_capitan
  end

  depends_on :java => "1.8"

  def install
    ENV["CIRCLE_TAG"] = version
    system "./gradlew", "shadowJar"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh", :java_version => "1.8"
  end

  test do
    system bin/"gssh"
  end
end
