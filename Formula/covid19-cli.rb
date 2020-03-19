class Covid19Cli < Formula
  desc "A simple command line tool to view COVID-19 statistics"
  homepage "www.iconicto.com"
  url "https://github.com/Suvink/COVID19-CLI/archive/v1.0.tar.gz"
  sha256 "a581464b9a192c62817f952cd8f12c8eacdcfed199c96168dd2fbe17ec3f7be7"


  def install
    bin.install "covid19-cli"
  end

end
