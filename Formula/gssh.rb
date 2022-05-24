class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.10.1.tar.gz"
  sha256 "d1a6e2293e4f23f3245ede7d473a08d4fb6019bf18efbef1a74c894d5c50d6a1"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ce6770535e1cb673b8b08918358a14ab02d06df3721d65a170d65e4b36a0680"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c356a6f35f6377301e86f13be938d7db63325140a97650c34696614c36196c2"
    sha256 cellar: :any_skip_relocation, monterey:       "3a65a2e6deb96da24f664ca4eaacce4034d30195d482fedd123a61f4498cac35"
    sha256 cellar: :any_skip_relocation, big_sur:        "31f745f57d10191ea547bdcfbbf544342a09b87a51b4298114baacc9f35589a0"
    sha256 cellar: :any_skip_relocation, catalina:       "170b7e0b5c81eb30f12471b8342f23179d5febff44835297d1648c124cd94733"
    sha256 cellar: :any_skip_relocation, mojave:         "d4f7b427c456b891a7604988bba90850c81da7d9714788383ab6e9083a763d1c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "51e468107da90b71b335a7dcdf0ff6149930634a8625cf2019d45add410d2852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaad8801891848cb3ce21624f38c36a60762a4b913c8c0751a6d34136af21ed3"
  end

  depends_on "openjdk@11"

  def install
    ENV["CIRCLE_TAG"] = version
    system "./gradlew", "shadowJar"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh"
  end

  test do
    system bin/"gssh"
  end
end
