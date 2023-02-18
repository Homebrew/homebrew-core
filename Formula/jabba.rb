class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  # fork blessed by previous maintener https://github.com/shyiko/jabba/issues/833#issuecomment-1338648294
  homepage "https://github.com/Jabba-Team/jabba"
  url "https://github.com/Jabba-Team/jabba/archive/0.12.1.tar.gz"
  sha256 "f4daa202771ad28108a0bf7fda441ad750214295fb590804d1f0735a41401257"
  license "Apache-2.0"
  head "https://github.com/Jabba-Team/jabba.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68d5ced2e54abef37987df91b3478df3d2a25a319ca3d5cfe9c0db0291bfe77b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fab37b12d5cf54f5c1a3baaa864a479a6eb8fcef9fc030b7ea2a677cf088b500"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9d75c5f9d93043021ddff479b8d169e15aa0258b13fcd7e0561062a04768e8c"
    sha256 cellar: :any_skip_relocation, ventura:        "ca99b445c3d328f265c4db633ffbacd0ca23efc4ea8330e030e2a5b8c18f8b0c"
    sha256 cellar: :any_skip_relocation, monterey:       "9f0ffb87c4003e40fe591f1773671f91b596e205fbc2a41bd3128dea7b623274"
    sha256 cellar: :any_skip_relocation, big_sur:        "0526621c1a08e1a62fb5f97a9ced58b3e53e55c25197d9b28b1438041f8cf636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d14f559339f3a71c005d66e27cc927b2d3318a6e41a460701780592e338e45"
  end

  depends_on "go" => :build

  def install
    ENV["JABBA_GET"] = "false"

    # Customize install locations
    # https://github.com/Jabba-Team/jabba/pull/17
    inreplace "Makefile", " sh install.sh", " bash install.sh --skip-rc"
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
