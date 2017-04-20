class Bullshtml < Formula
  desc "Html Reporter for BullseyeCoverage tool."
  homepage "https://github.com/RafalSkorka/bullshtml"
  url "https://github.com/RafalSkorka/bullshtml.git",
      :tag => "1.0.6",
      :revision => "43efec2ff5ea7db9622c679616908aeacf46e7b8"

  depends_on "ant" => :build
  depends_on :java => "1.6+"

  def install
    ENV.java_cache
    system "ant", "make_onejar", "-Ddebuglevel=none"

    libexec.install "target/bullshtml.jar"
    (bin/"bullshtml").write <<-EOS.undent
      #!/bin/bash
      exec java -jar #{libexec}/bullshtml.jar "$@"
    EOS
  end

  test do
    system bin/"bullshtml", "-h"
  end
end
