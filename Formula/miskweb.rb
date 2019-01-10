class Miskweb < Formula
  desc "CLI for managing Misk-Web projects"
  homepage "https://github.com/square/misk-web/"

  version "0.1.3"

  os = `uname`

  if os == "Linux"
    stable do
      url 'https://github.com/square/misk-web/raw/master/misk-web/web/packages/@misk/cli/bin/linux/miskweb', :using => :curl
    end
  else
    stable do
      url 'https://github.com/square/misk-web/raw/master/misk-web/web/packages/@misk/cli/bin/macos/miskweb', :using => :curl
    end
  end

  def install
    bin.install 'miskweb'
  end
end
