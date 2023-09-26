class Devtunnel < Formula
  desc "Microsoft Devtunnel allow developers to securely share local web services"
  homepage "https://aka.ms/devtunnels/docs"
  url "https://tunnelsassetsprod.blob.core.windows.net/cli/1.0.922+fa34179138/osx-x64-devtunnel-zip"
  sha256 "d9875469d96c563302cb68d1bd6834bde6ba949ace57714a86ecd0108073da1e"
  license "MIT"

  def install
    bin.install "devtunnel"
  end

  test do
    #system "false"
    resource("testdata") do
      url "https://tunnelsassetsprod.blob.core.windows.net/cli/1.0.922+fa34179138/osx-x64-devtunnel-zip"
      sha256 "d9875469d96c563302cb68d1bd6834bde6ba949ace57714a86ecd0108073da1e"
    end
    
    test do
      resource("testdata").stage do
        assert_match "OK", shell_output("#{bin}/devtunnel build-devtunnel input.devtunnel")
      end
    end
  end
end
