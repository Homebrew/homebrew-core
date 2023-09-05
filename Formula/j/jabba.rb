class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  # fork blessed by previous maintener https://github.com/shyiko/jabba/issues/833#issuecomment-1338648294
  homepage "https://github.com/Jabba-Team/jabba"
  url "https://github.com/Jabba-Team/jabba/archive/0.12.2.tar.gz"
  sha256 "44bd276fde1eaab56dc8a32ec409ba6eee5007f3a640951b3e8908c50f032bcd"
  license "Apache-2.0"
  head "https://github.com/Jabba-Team/jabba.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a27f8c6f6c058bfbc5f98d6ad1037013c1849f80f4d05cda274fa8a8d1e6159"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16c46cd77f9daea31252b1cc479ed71a598ba385a984a16fd8d4b33303b32808"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91ac15457375b816ee6b90ed999d105414463cae66df68db4829513f0324d386"
    sha256 cellar: :any_skip_relocation, ventura:        "3faf882dd022a5691e5e7a1d3db04104bdc17d0674abe69a6ef7dc1405a44104"
    sha256 cellar: :any_skip_relocation, monterey:       "c3ecfed12f4067413173cdf391b9ba9b1e9e66eee20ed80ef32a58757167dde6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef83f5290a46b7f0d121b1eccf40869b964b0a8134e6cdb033d2715719086e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e4532d576e0f24ee5b043b7a554569c3014a163f71a3cf2177ffa9ffc4026e2"
  end

  depends_on "go" => :build

  def install
    ENV["JABBA_GET"] = "false"

    # Customize install locations
    # https://github.com/Jabba-Team/jabba/pull/17
    inreplace "Makefile", " bash install.sh", " bash install.sh --skip-rc"
    inreplace "install.sh" do |s|
      s.gsub! "  rm -f", "  command rm -f"
      s.gsub! "$JABBA_HOME_TO_EXPORT/bin/jabba", "#{opt_bin}/jabba"
      s.gsub! "${JABBA_HOME}/bin", bin.to_s
      s.gsub! "${JABBA_HOME}/jabba.sh", "#{pkgshare}/jabba.sh"
      s.gsub! "${JABBA_HOME}/jabba.fish", "#{pkgshare}/jabba.fish"
    end

    pkgshare.mkpath

    system "make", "VERSION=#{version}", "install"
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
