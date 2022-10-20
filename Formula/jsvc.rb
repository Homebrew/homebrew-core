class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.3.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.3.2-src.tar.gz"
  sha256 "5dde89fd338608302d065ddb68a2673989f3b491fe0be2f6f9ef510b4054a84c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd279e71ff6295eeb2f610215e96f7b1b3315abe63878406b8e287deb22fafa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1f5f3a1d20e6da90dfe2e63a91ad43343b5c734ef4835cd3157cb204c284c9b"
    sha256 cellar: :any_skip_relocation, monterey:       "b7beb523aa6aaaa660b14592cc7e83b3af241397b93d8e98c477930e35621a0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ca8e7af372e8d0ca52ada25068c0e762a9000335fcbda8e8951c7f8ec2f9cac"
    sha256 cellar: :any_skip_relocation, catalina:       "b663e3f04c50764a1339a4de0b579d3933860a19dc30ba970cd2f7312dc9bdb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2b2b984aea61dfa943f3677dac28acf09bb44339e6da4adc2de397bdb95388e"
  end

  depends_on "openjdk"

  def install
    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      system "./configure", "--with-java=#{Formula["openjdk"].opt_prefix}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", Language::Java.overridable_java_home_env
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end
