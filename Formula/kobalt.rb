class Kobalt < Formula
  desc "Build system"
  homepage "http://beust.com/kobalt"
  url "https://github.com/cbeust/kobalt/releases/download/1.0.26/kobalt-1.0.26.zip"
  sha256 "767a8b7aa3f18f480d405a7858d281a0bb077d6083bedd2d2c9b3b135bc9245a"

  bottle :unneeded

  def install
    libexec.install %w[kobalt]

    (bin/"kobaltw").write <<-EOS.undent
      #!/bin/bash
      java -jar #{libexec}/kobalt/wrapper/kobalt-wrapper.jar $*
    EOS
  end

  test do
    ENV.java_cache

    (testpath/"src/main/kotlin/com/A.kt").write <<-EOS.undent
      package com
      class A
      EOS

    (testpath/"kobalt/src/Build.kt").write <<-EOS.undent
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
    assert File.exist?(output), "Couldn't find #{output}"
  end
end
