class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "https://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.9.20.jar"
  sha256 "2c1db625583854fcbd5851a6e927dd06e28f375d9ba4dbc5e15e1dcd7bfa06fa"

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
