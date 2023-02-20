class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  # fork blessed by previous maintener https://github.com/shyiko/jabba/issues/833#issuecomment-1338648294
  homepage "https://github.com/Jabba-Team/jabba"
  url "https://github.com/Jabba-Team/jabba/archive/0.12.2.tar.gz"
  sha256 "44bd276fde1eaab56dc8a32ec409ba6eee5007f3a640951b3e8908c50f032bcd"
  license "Apache-2.0"
  head "https://github.com/Jabba-Team/jabba.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cc7bf2459997c184493c2b3ee2db66439c02fee4cd65a70ffee3c8f4fb00311"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e89e5313435d4ef86ad7a6670f87cacaac13cd9cfbad3d34d987a53196f12dc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e685947d36c86746a9dc1819a29e8a9fa03d16a4915263d45b37802ca8845e0"
    sha256 cellar: :any_skip_relocation, ventura:        "d3d425f7777ca12f8ffc0e440d7303bb1ac6a19bf8bafdf326c2e2cf95830f42"
    sha256 cellar: :any_skip_relocation, monterey:       "7d1174ab957c14353ac767f792be07832331e995a1e15d947b1f1e256557bc93"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e42f37a50d9a1ac185ca3adfefbe341ffd8150d8a49e6bd6b063076a528986d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "315baf57135ee0d42aec6d36ff02509e07b5e6de76832ee60f0f47bb3d5c6f1b"
  end

  depends_on "go" => :build

  def install
    ENV["JABBA_GET"] = "false"

    # Customize install locations
    # https://github.com/Jabba-Team/jabba/pull/17
    inreplace "Makefile", "bash install.sh", " bash install.sh --skip-rc"
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
