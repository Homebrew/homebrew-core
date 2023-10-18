class Jabba < Formula
  desc "Cross-platform Java Version Manager"
  # fork blessed by previous maintener https://github.com/shyiko/jabba/issues/833#issuecomment-1338648294
  homepage "https://github.com/Jabba-Team/jabba"
  url "https://github.com/Jabba-Team/jabba/archive/0.13.0.tar.gz"
  sha256 "113124e3235cce0e8d66425ceef541c664f2dd8034c611caf04f566191d2628c"
  license "Apache-2.0"
  head "https://github.com/Jabba-Team/jabba.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "263ae4edfbebdf8a49b0182510cac8cb3998245ee4c40ab75e51da084a0964e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b3a32d39f59e117e03b8f80d7b3e99e407c2829389e5998f02bf52925318a70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d1859dac7d8b95df9af78ff90f8ef51ee3e0136d99cbf0b976febb01699dab0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3974cb813f27fb01b15460627d08523297d71c8b0db42a29700945e2a377bf42"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8966004869954c807d4e039455f99f5c4514efb5755858e7c5c0c36e76a6742"
    sha256 cellar: :any_skip_relocation, ventura:        "aa6409d1ec75a1f2655870d8ee7b3ba69b74f8e479be8b4141e4ce0f5601a03f"
    sha256 cellar: :any_skip_relocation, monterey:       "7a3e1964113c9c264750cdb56194b9cae1fac077f3f4085736ae6693b70418ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "675cc7a5d6ef3c770d94125f2a70f7886f28f68c4b573e419f164dcae49f62a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b010997b4372c1297fac71595397b396684ccc5c399f485b1ceb11ddd6fbfeb"
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
