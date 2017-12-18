class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://archive.apache.org/dist/jena/binaries/apache-jena-3.6.0.tar.gz"
  sha256 "a76415af2c70d74110accc473443bd2a18f66a7392a97f3367fdd0efe530e314"

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
