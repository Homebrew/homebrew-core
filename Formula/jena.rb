class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://archive.apache.org/dist/jena/binaries/apache-jena-3.1.0.tar.gz"
  sha256 "532ad87eab7792ff1ffae34375d4c27956aada7c659743c39027e8b48f29cbd9"

  bottle :unneeded

  def shim_script(target)
    <<-EOS.undent
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
