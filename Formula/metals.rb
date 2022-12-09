class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v0.11.9.tar.gz"
  sha256 "ff8f401f483f3a7f67bc083732bba2b3180bfb190141ad70fedcfc2d5b6fdb78"
  license "Apache-2.0"

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    inreplace "build.sbt", /version ~=.+?,/m, "version := \"#{version}\","

    system "sbt", "package"

    # Following Arch AUR to get the dependencies.
    dep_pattern = /^.+?Attributed\((.+?\.jar)\).*$/
    sbt_deps_output = `sbt 'show metals/dependencyClasspath' 2>/dev/null`
    deps_jars = sbt_deps_output.lines.grep(dep_pattern) { |it| it.strip.gsub(dep_pattern, '\1') }
    deps_jars.each do |jar|
      (libexec/"lib").install jar
    end

    ["metals", "mtags", "mtags-interfaces"].each do |pkg|
      (libexec/"lib").install buildpath.glob("#{pkg}/target/**/#{pkg}*-#{version}.jar")
    end

    (bin/"metals").write <<~EOS
      #!/bin/bash

      export JAVA_HOME="#{Language::Java.overridable_java_home_env[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -cp "#{libexec/"lib"}/*" "scala.meta.metals.Main" "$@"
    EOS
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/metals", input, 0)

    assert_match(/^Content-Length: \d+/i, output)
  end
end
