class ApachePulsar < Formula
  desc "Cloud-native distributed messaging and streaming platform"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-2.8.0/apache-pulsar-2.8.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.8.0/apache-pulsar-2.8.0-src.tar.gz"
  sha256 "0e161a81c62c7234c1e0c243bb6fe30046ec1cd01472618573ecdc2a73b1163b"
  license "Apache-2.0"
  head "https://github.com/apache/pulsar.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on "openjdk@11"

  def install
    chmod "+x", "src/rename-netty-native-libs.sh"
    with_env(
      "PATH"      => "#{Formula["openjdk@11"].bin}:#{ENV["PATH"]}",
      "JAVA_HOME" => Formula["openjdk@11"].opt_prefix,
      "TMPDIR"    => buildpath,
    ) do
      system "mvn", "-X", "clean", "package", "-DskipTests", "-Pcore-modules"
    end
    system "tar", "-xf", "distribution/server/target/apache-pulsar-#{version}-bin.tar.gz"
    binpfx = "apache-pulsar-#{version}"
    libexec.install binpfx+"/bin", binpfx+"/lib", binpfx+"/instances", binpfx+"/conf"
    share.install binpfx+"/examples"
    share.install binpfx+"/licenses"
    (var/"log/pulsar").mkpath
    (etc/"pulsar").install_symlink libexec/"conf/*"

    Pathname.glob("#{libexec}/bin/*") do |path|
      if path.fnmatch?("*common.sh") || path.directory?
        bin.install path
      else
        bin_name = path.basename
        (bin+bin_name).write <<~EOS
          #!/bin/bash
          export PATH="#{Formula["openjdk@11"].bin}:$PATH"
          export JAVA_HOME="#{Formula["openjdk@11"].opt_prefix}"
          exec "#{libexec}/bin/#{bin_name}" "$@"
        EOS
      end
    end
  end

  plist_options manual: "pulsar standalone"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{bin}/pulsar</string>
            <string>standalone</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{prefix}</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/pulsar/output.log</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/pulsar/error.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    output = shell_output("#{bin}/pulsar version")
    assert_match "Current version of pulsar is: #{version}", output
  end
end
