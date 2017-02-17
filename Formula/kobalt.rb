class Kobalt < Formula
  desc "Build system"
  homepage "http://beust.com/kobalt"
  url "https://github.com/cbeust/kobalt/releases/download/0.932/kobalt-0.932.zip"
  sha256 "5d3cea6b7a362824f3a8876d47dc305b333da018301a06ef4def850f67717c94"

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
