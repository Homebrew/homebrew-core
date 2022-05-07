class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "60f88048c517164deb8283435a21e942c3ea39f4bb7ea674a6f83fb0d211bc09"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    system Formula["gradle"].bin/"gradle", "build", "jar"
    prefix.install "build/libs/flix-#{version}.jar"
    (bin/"flix").write <<~EOS
      #!/bin/bash
      CLASSPATH="#{prefix}/flix-#{version}.jar:." exec "#{Formula["openjdk"].opt_bin}/java" -jar #{prefix}/flix-#{version}.jar "$@"
    EOS
  end

  test do
    system bin/"flix", "init"
    system bin/"flix", "run"
    system bin/"flix", "test"
  end
end
