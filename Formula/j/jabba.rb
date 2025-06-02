class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  # fork blessed by previous maintener https://github.com/shyiko/jabba/issues/833#issuecomment-1338648294
  homepage "https://github.com/Jabba-Team/jabba"
  url "https://github.com/Jabba-Team/jabba/archive/refs/tags/0.14.0.tar.gz"
  sha256 "9de92172ba62cbdf6e38cc9831466682717b3573bc2dfa8213baa5766c9ce2e3"
  license "Apache-2.0"
  head "https://github.com/Jabba-Team/jabba.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ca270e89401f037f27bbba15909d74e3bd2caaaaec257a68720fec024b53e3fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7ca771e6e62bfe218b66cca1345f0fadf74231d6b5b0264816582102ade7ec4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3e0407cf46ffb79d431e20da70d23080391585438fef6681415d4bde01f8094"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12f33d23591f130fcd82fb08d02ef355cc359819e9f690a8412b4c46486feadf"
    sha256 cellar: :any_skip_relocation, sonoma:         "beb282b92dc05fdbc6547d8abb9c1adcb4af6baf23182faa40272090b6fd1d29"
    sha256 cellar: :any_skip_relocation, ventura:        "030068b5dbb9d739d9020d94f038bdfa0263fc7b96d6c1986a93322d9ff6972d"
    sha256 cellar: :any_skip_relocation, monterey:       "bdd8ffb05d7136a668b135865e4ec2e3a3d76d04fd89352113ad94664c7de909"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3245fe15e6e1f23e23ac3a4dcd94634399e0c0ed5898550a3784c11f2c0fcee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c3d858b92c8729670829b405334bcdec1a46e375133996510e0a318afa5f9dc"
  end

  depends_on "go" => :build

  def install
    ENV["JABBA_GET"] = "false"
    inreplace "Makefile", " bash install.sh", " bash install.sh --skip-rc"
    system "make", "install", "VERSION=#{version}", "JABBA_HOME=#{prefix}"
  end

  def caveats
    <<~EOS
      Add the following line to your ~/.bashrc or ~/.zshrc file:
        [ -s "#{opt_pkgshare}/jabba.sh" ] && . "#{opt_pkgshare}/jabba.sh"

      If you use the Fish shell then add the following line to your ~/.config/fish/config.fish:
        [ -s "#{opt_pkgshare}/jabba.fish" ]; and source "#{opt_pkgshare}/jabba.fish"
    EOS
  end

  test do
    ENV["JABBA_HOME"] = testpath/"jabba_home"
    jdk_version = "zulu@17"
    system bin/"jabba", "install", jdk_version
    jdk_path = assert_match(/^export JAVA_HOME="([^"]+)"/,
                           shell_output("#{bin}/jabba use #{jdk_version} 3>&1"))[1]
    assert_match 'openjdk version "17',
                 shell_output("#{jdk_path}/bin/java -version 2>&1")
  end
end
