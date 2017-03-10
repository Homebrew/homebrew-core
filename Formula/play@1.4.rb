class PlayAT14 < Formula
  desc "Play’s goal is to ease Java web applications development."
  homepage "https://www.playframework.com"
  url "https://downloads.typesafe.com/play/1.4.2/play-1.4.2.zip"
  sha256 "b2067f59df5b4c4f9fa542af1f234abd38ac30b5fc8e4e61fb10cfc043c0434c"

  bottle :unneeded

  def install
    rm_rf "python" # we don't need the bundled Python for windows
    rm Dir["*.bat"]
    libexec.install Dir["*"]
    chmod 0755, libexec/"play"
    bin.install_symlink libexec/"play"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/play new #{testpath}/app") do |stdin, _, _|
      stdin.write "\n"
      stdin.close
    end
    %w[app conf lib public test].each do |d|
      File.directory? testpath/"app/#{d}"
    end
  end
end
