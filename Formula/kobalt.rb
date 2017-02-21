class Kobalt < Formula
  desc "Build system"
  homepage "http://beust.com/kobalt"
  url "https://github.com/cbeust/kobalt/releases/download/0.939/kobalt-0.939.zip"
  sha256 "59fee164873f74323accdb69f8b2d7e23db6266130f0d9e3fa0579c7f3cc6229"

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
