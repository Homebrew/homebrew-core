class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "https://www.embulk.org/"
  # https://www.embulk.org/articles/2020/03/13/embulk-v0.10.html
  # v0.10.* is a "development" series, not for your production use.
  # In your production, keep using v0.9.*.
  url "https://github.com/embulk/embulk/releases/download/v0.10.15/embulk-0.10.15.jar"
  sha256 "4f14f446eafc121297ffa08b17af86eef253289cec71cfe66b6f67059ceeb4e7"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(%r{Stable.+?href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}im)
  end

  bottle :unneeded

  depends_on java: "1.8"

  def install
    # Execute through /bin/bash to be compatible with OS X 10.9.
    libexec.install "embulk-#{version}.jar" => "embulk.jar"
    (bin/"embulk").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env("1.8")[:JAVA_HOME]}"
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
