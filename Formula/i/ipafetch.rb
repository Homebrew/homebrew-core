class Ipafetch < Formula
  desc "A tool to fetch IPA files from Apple Configurator"
  homepage "https://github.com/drewg233/ipafetch"
  url "https://github.com/drewg233/ipafetch.git", branch: "main"
  version "0.1.0"
  license "MIT"

  depends_on "python@3.11"

  def install
    python = Formula["python@3.11"].opt_prefix/"Frameworks/Python.framework/Versions/3.11/bin/python3.11"
    
    # Verify Python exists
    unless File.exist?(python)
      raise "Python 3.11 not found at #{python}"
    end
    
    # Create a wrapper script with absolute paths
    (bin/"ipafetch").write <<~EOS
      #!/bin/bash
      if [ ! -f "#{python}" ]; then
        echo "Error: Python 3.11 not found. Please run: brew install python@3.11"
        exit 1
      fi
      exec "#{python}" "#{libexec}/ipafetch.py" "$@"
    EOS
    chmod 0755, bin/"ipafetch"

    # Install the Python script
    libexec.install "ipafetch/ipafetch.py"
  end

  test do
    system "#{bin}/ipafetch", "--help"
  end
end 