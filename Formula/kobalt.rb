class Kobalt < Formula
  desc "Build system"
  homepage "http://beust.com/kobalt"
  url "https://github.com/cbeust/kobalt/releases/download/1.0.111/kobalt-1.0.111.zip"
  sha256 "986bb217263b8ab8ca9164e502ed0cb7f907d70f6206178b07345a2dec0eaac8"

  bottle :unneeded

  def install
    libexec.install "kobalt-#{version}/kobalt"

    (bin/"kobaltw").write <<~EOS
      #!/bin/bash
      java -jar #{libexec}/kobalt/wrapper/kobalt-wrapper.jar $*
    EOS
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
