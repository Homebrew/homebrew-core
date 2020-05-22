class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jena/binaries/apache-jena-3.15.0.tar.gz"
  mirror "https://archive.apache.org/dist/jena/binaries/apache-jena-3.15.0.tar.gz"
  sha256 "6e50f7426d7d607db93ded55e8f6d3b928fedf5cfc80a4b56be646bb45f42a9d"

  bottle :unneeded

  def shim_script(target)
    <<~EOS
      #!/usr/bin/env bash
      export JENA_HOME="#{libexec}"
      "$JENA_HOME/bin/#{target}" "$@"
    EOS
  end

  def install
    rm_rf "bat" # Remove Windows scripts

    prefix.install %w[LICENSE NOTICE README]
    libexec.install Dir["*"]
    Dir.glob("#{libexec}/bin/*") do |path|
      bin_name = File.basename(path)
      (bin/bin_name).write shim_script(bin_name)
    end
  end

  test do
    system "#{bin}/sparql", "--version"
  end
end
