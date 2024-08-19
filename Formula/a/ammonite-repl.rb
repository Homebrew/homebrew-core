class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://ammonite.io/"
  url "https://github.com/com-lihaoyi/Ammonite/releases/download/3.0.0-M2/3.3-3.0.0-M2"
  version "3.0.0-M2"
  sha256 "184ad1490dd4b91fc84843cd629369985f67ba7c00393d5fdb36f3f6416e7046"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/^v?(\d+(?:\.\d+)+[._-]M\d)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d43b0d86cc9a7c9aa083ad2b100ea24a38837ea4fe4bb723093a604392f7ae5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22841036bdda30665ffacc33790fce326dae7518e6b5b10dd1ec3b9c325932f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c93a4508b10e0769679dfaecb08db61fee22a593651addcb73800f1600242564"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bf78b7fc9e21fcd9419b83092b94de7fa6cccc3d535cc7b882aa26a1f8063e2"
    sha256 cellar: :any_skip_relocation, ventura:        "5ecde04b59e47a7b4c87f521150c702432ea59fec06033c552d6b3e2972849e0"
    sha256 cellar: :any_skip_relocation, monterey:       "ee35593c01b28b4f31fd6bd69b3976170d391068ce2aa8c425472997308d5874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cee20029939be87e1440536e7405f538db3d823497cc7a121c7d7fbbb10390f9"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install Dir["*"].first => "amm"
    chmod 0755, libexec/"bin/amm"
    env = Language::Java.overridable_java_home_env
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"amm").write_env_script libexec/"bin/amm", env
  end

  test do
    (testpath/"testscript.sc").write <<~EOS
      #!/usr/bin/env amm
      @main
      def fn(): Unit = println("hello world!")
    EOS
    output = shell_output("#{bin}/amm #{testpath}/testscript.sc")
    assert_equal "hello world!", output.lines.last.chomp
  end
end
