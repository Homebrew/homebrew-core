class Mill < Formula
  desc "Scala build tool"
  homepage "https://com-lihaoyi.github.io/mill/mill/Intro_to_Mill.html"
  url "https://github.com/com-lihaoyi/mill/releases/download/0.10.12/0.10.12-assembly"
  sha256 "3253e724cbb3df965df95430bec69d4513d42de6d1ec658dd6f195f9c27bb387"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "39845478ccbb762e1cbe8222bc5c16ac984bb460358c530960fb8845070dc192"
  end

  # TODO: switch back to `openjdk` when Scala 2.13.11 or newer is used. Check:
  # https://github.com/com-lihaoyi/mill/blob/#{version}/build.sc#L81
  depends_on "openjdk@17"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.overridable_java_home_env("17")
  end

  test do
    (testpath/"build.sc").write <<~EOS
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.12.8"
      }
    EOS
    output = shell_output("#{bin}/mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end
