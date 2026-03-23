class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  # fork blessed by previous maintener https://github.com/shyiko/jabba/issues/833#issuecomment-1338648294
  homepage "https://github.com/Jabba-Team/jabba"
  url "https://github.com/Jabba-Team/jabba/archive/refs/tags/0.15.0.tar.gz"
  sha256 "36607ef03a196719403f138e3d7f5591f6ed253b772e82501849bb95fdb47a2b"
  license "Apache-2.0"
  head "https://github.com/Jabba-Team/jabba.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ad1617eea05f061bf712ec27367696f9ce94de19c9640f87b4c826198843f27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e23e383d60bef6a4a7a62bede2102907a3eb70b410017554b07ec2a19e7129cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "072a21b1e3ff6d119ecd82b9fab18ccec57dad41334f5e9e7a78c8ad5fb6e4d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b09a6b0160a4a952d440eba94a5ec65a4988faaef0c24b3151cab3b92c082874"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2de862360086fe9b87293e4eb6e2b0ababde201289a570343379dc31ec99368e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca6d53eede11f5eab0c9b75e53ac133f978a3978491452c2bca2c4411a0e9b36"
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
