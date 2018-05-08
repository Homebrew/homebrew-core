class Kotlinreplacesupporter < Formula
  desc "This is a tool of replacing"
  homepage "https://github.com/youmitsu/KotlinReplaceSupporter"
  url "https://github.com/youmitsu/KotlinReplaceSupporter/releases/download/1.0/kotlin_replace_supporter-1.0.jar"
  sha256 "f7b5feafaea72057235809f6d587539863eb6f5785fa044ff42f891ef91d55e6"
  depends_on :java => "1.6+"

  def install
    libexec.install "kotlin_replace_supporter-1.0.jar"
    bin.write_jar_script libexec/"kotlin_replace_supporter-1.0.jar", "krs"
  end
  test do
    system "#{bin}/krs"
  end
end
