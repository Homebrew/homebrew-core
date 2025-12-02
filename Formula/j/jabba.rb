class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  # fork blessed by previous maintener https://github.com/shyiko/jabba/issues/833#issuecomment-1338648294
  homepage "https://github.com/Jabba-Team/jabba"
  url "https://github.com/Jabba-Team/jabba/archive/refs/tags/0.14.0.tar.gz"
  sha256 "9de92172ba62cbdf6e38cc9831466682717b3573bc2dfa8213baa5766c9ce2e3"
  license "Apache-2.0"
  head "https://github.com/Jabba-Team/jabba.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "946d898c5d8ceb5268dc1d203b639b73a4fd16d3a92f70f336db2f69b779e18c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed963ce1acd1ea436f05349d5093ed85a72d76cf034e690ae0430fa9084e8314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "451bfa6f56c2c4f10da5bf96d5fb884adafdd6af95fc6644f77009bac128b76f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fadf80b7fb688e556dd76eda7ef195f0e3621357226f95ba2bedb26db647c041"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c05ea18167c83b1582d6a342ad3004ca772c0773e44504cd7edaa693c31a43a"
    sha256 cellar: :any_skip_relocation, ventura:       "2ea99aef72e1eab77ca3b0b8ba357b789f9957b7975a4fc1080c40290326f0e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "100f60eb6c134605692c706ccb22de23398028c4cb8d5219fa675c96c40ba9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4d4d436fde9d35a6955805b447061a877867995fba0d992c1302067bd61edf7"
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
        [ -s "#{opt_prefix}/jabba.sh" ] && . "#{opt_prefix}/jabba.sh"

      If you use the Fish shell then add the following line to your ~/.config/fish/config.fish:
        [ -s "#{opt_prefix}/jabba.fish" ]; and source "#{opt_prefix}/jabba.fish"
    EOS
  end

  test do
    assert_path_exists opt_prefix/"jabba.sh", "Caveat is outdated!"
    assert_path_exists opt_prefix/"jabba.fish", "Caveat is outdated!"

    ENV["JABBA_HOME"] = testpath/"jabba_home"
    jdk_version = "zulu@17"
    system bin/"jabba", "install", jdk_version
    jdk_path = assert_match(/^export JAVA_HOME="([^"]+)"/,
                           shell_output("#{bin}/jabba use #{jdk_version} 3>&1"))[1]
    assert_match 'openjdk version "17',
                 shell_output("#{jdk_path}/bin/java -version 2>&1")
  end
end
