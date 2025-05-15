class Ipv6utils < Formula
  desc "A toolset for IPv6 utilities"
  homepage "https://github.com/buraglio/ipv6utils"
  url "https://github.com/buraglio/ipv6utils/archive/refs/tags/v2.tar.gz"
  sha256 "088f46de98b3f8e906c8f06ca44b17ce10de4da412664f48e5ceacc87667a6b6"  
  depends_on "go"  #  Ensures Go is installed to build the project

  def install
    # Build the Go project
    system "go", "build", "-o", bin/"ipv6utils"

   
  end

  test do
    # A simple test to verify the install
    system "#{bin}/ipv6utils", "-h"
  end
end
