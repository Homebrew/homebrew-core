class Kobalt < Formula
  desc "Build system"
  homepage "https://beust.com/kobalt/"
  url "https://github.com/cbeust/kobalt/releases/download/1.0.129/kobalt-1.0.129.zip"
  sha256 "0b4db9992f18f3b04503aa09dbb690bb12761552b392e24d49b04cc77b8bff68"
  license "Apache-2.0"

  # https://github.com/cbeust/kobalt/issues/510
  disable! date: "2021-06-28", because: :unmaintained

  depends_on "openjdk"

  def install
    libexec.install "kobalt-#{version}/kobalt"
    jar = libexec/"kobalt/wrapper/kobalt-wrapper.jar"
    bin.write_jar_script jar, "kobaltw"
  end

  test do
    (testpath/"src/main/kotlin/com/A.kt").write <<~EOS
      package com
      class A
    EOS

    (testpath/"kobalt/src/Build.kt").write <<~EOS
      import com.beust.kobalt.*
      import com.beust.kobalt.api.*
      import com.beust.kobalt.plugin.packaging.*

      val p = project {
        name = "test"
        version = "1.0"
        assemble {
          jar {}
        }
      }
    EOS

    system "#{bin}/kobaltw", "assemble"
    output = "kobaltBuild/libs/test-1.0.jar"
    assert_predicate testpath/output, :exist?, "Couldn't find #{output}"
  end
end
