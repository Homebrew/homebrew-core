class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "https://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.9.18.jar"
  sha256 "9a12f86ff39ca790725732ded7d8f16bd5457c72451ebcfe83ac4c4f76acea51"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Execute through /bin/bash to be compatible with OS X 10.9.
    libexec.install "embulk-#{version}.jar" => "embulk.jar"
    (bin/"embulk").write <<~EOS
      #!/bin/bash
      export JAVA_HOME=$(#{Language::Java.java_home_cmd("1.8")})
      exec /bin/bash "#{libexec}/embulk.jar" "$@"
    EOS
  end

  test do
    system bin/"embulk", "example", "./try1"
    system bin/"embulk", "guess", "./try1/seed.yml", "-o", "config.yml"
    system bin/"embulk", "preview", "config.yml"
    system bin/"embulk", "run", "config.yml"
  end
end
