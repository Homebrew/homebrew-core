class Kobalt < Formula
  desc "Build system"
  homepage "http://beust.com/kobalt"
  url "https://github.com/cbeust/kobalt/releases/download/1.0.86/kobalt-1.0.86.zip"
  sha256 "646327f8b8c7bdb19c5fc4418ccc34905a29ce161a0defbed8d0f7ca8acc87c2"

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
