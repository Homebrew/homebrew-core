class Ipafetch < Formula
  desc "Tool to fetch IPA files from Apple Configurator"
  homepage "https://github.com/drewg233/ipafetch"
  url "https://github.com/drewg233/ipafetch.git",
      tag:      "v0.1.0",
      revision: "HEAD" # Replace with actual git commit hash
  license "MIT"

  depends_on "python@3.11"

  def install
    python = Formula["python@3.11"].opt_prefix/"Frameworks/Python.framework/Versions/3.11/bin/python3.11"
    raise "Python 3.11 not found at #{python}" unless File.exist?(python)

    # Create a wrapper script with absolute paths
    (bin/"ipafetch").write <<~EOS
      #!/bin/bash
      exec "#{python}" "#{libexec}/ipafetch.py" "$@"
    EOS
    chmod 0755, bin/"ipafetch"

    # Install the Python script
    libexec.install "ipafetch/ipafetch.py"
  end

  test do
    assert_match "IPA Fetcher", shell_output("#{bin}/ipafetch --help")
  end
end