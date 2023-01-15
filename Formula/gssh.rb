class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.11.0.tar.gz"
  sha256 "86dba70bc6370af9db2e1364c1c97dc57f884703bc6814c7a845ec2bdf1ed279"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb94322029d9beb3032089198fb9b755b38396151200ac14bd1be0e333f6e6bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ce6770535e1cb673b8b08918358a14ab02d06df3721d65a170d65e4b36a0680"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c356a6f35f6377301e86f13be938d7db63325140a97650c34696614c36196c2"
    sha256 cellar: :any_skip_relocation, ventura:        "f26a11d822bed47b4960fca1815ae2b2cdaca3c665c9e538aed4ce675a7b2521"
    sha256 cellar: :any_skip_relocation, monterey:       "3a65a2e6deb96da24f664ca4eaacce4034d30195d482fedd123a61f4498cac35"
    sha256 cellar: :any_skip_relocation, big_sur:        "31f745f57d10191ea547bdcfbbf544342a09b87a51b4298114baacc9f35589a0"
    sha256 cellar: :any_skip_relocation, catalina:       "170b7e0b5c81eb30f12471b8342f23179d5febff44835297d1648c124cd94733"
    sha256 cellar: :any_skip_relocation, mojave:         "d4f7b427c456b891a7604988bba90850c81da7d9714788383ab6e9083a763d1c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "51e468107da90b71b335a7dcdf0ff6149930634a8625cf2019d45add410d2852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaad8801891848cb3ce21624f38c36a60762a4b913c8c0751a6d34136af21ed3"
  end

  depends_on "openjdk@11"

  # Fix shadowJar build failure, remove in next release
  patch do
    url "https://github.com/int128/groovy-ssh/commit/87913563ebb96c95a9fd17737c56aeff29916f0a.patch?full_index=1"
    sha256 "c4c41e991ebb2eed737fb4bc90667a4b1f00958cabe8c4a5695c855072c7aeaf"
  end

  def install
    ENV["CIRCLE_TAG"] = version
    ENV["VERSION"] = version
    system "./gradlew", "shadowJar"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh"
  end

  test do
    assert_match "groovy-ssh-#{version}", shell_output("#{bin}/gssh --version")
  end
end
