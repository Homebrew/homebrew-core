class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.8.9.jar"
  sha256 "f6329f7db9bae1125fd226bd9dc4e14dcc9f3e3070f9fa08c1f8c15d25a7360b"

  bottle :unneeded

  depends_on :java

  skip_clean "libexec"

  def install
    (libexec/"bin").install "embulk-#{version}.jar" => "embulk"
    chmod 0755, libexec/"bin/embulk"
    bin.write_exec_script libexec/"bin/embulk"
  end

  test do
    system bin/"embulk", "example", "./try1"
    system bin/"embulk", "guess", "./try1/seed.yml", "-o", "config.yml"
    system bin/"embulk", "preview", "config.yml"
    system bin/"embulk", "run", "config.yml"
  end
end
