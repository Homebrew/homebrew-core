class CustomDownloadStrategy < CurlDownloadStrategy
  def fetch
    CurlDownloadStrategy.new(url, name, version, **meta).fetch
    ENV["flat_download_location"] = cached_location
  end
end

class Flat < Formula
  desc "Flattens json or yaml structure"
  homepage "https://bit.ly/tiago-flat-script-v0-0-2"
  url "https://bit.ly/tiago-flat-script-v0-0-2", :using => CustomDownloadStrategy
  version "0.0.2"
  sha256 "97654f6f3d5084c7f8aef147c50be20a2272f4c0c048c731f635dfce38cdabcb"

  def install
    downloaded_file = File.read ENV["flat_download_location"]
    file = "flat"
    File.write file, downloaded_file
    bin.install file
  end

  test do
    assert_match "Usage: flat", shell_output("#{bin}/flat --help")
  end
end
