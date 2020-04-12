class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "https://www.embulk.org/"
  # https://www.embulk.org/articles/2020/03/13/embulk-v0.10.html
  # v0.10.* is a "development" series, not for your production use.
  # In your production, keep using v0.9.*.
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.9.23.jar"
  sha256 "153977fad482bf52100dd96f47e897c87b48de4fb13bccd6b3101475d3a5ebb9"

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
