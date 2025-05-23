class Clone < Formula
  desc "Download only a specific branch or tag without downloading the entire history"
  homepage "https://github.com/lizongying/ungit"
  version "0.1.6"
  license "MIT"
  head "https://github.com/lizongying/ungit.git", branch: "main"

  on_arm do
    url "https://github.com/lizongying/ungit/releases/download/v0.1.6/ungit_aarch64-apple-darwin"
    sha256 "bfc0aa642ee803f324aa4c05112da3158970cc88fe744d7f2deccde8ee0d4b41"
  end
  on_intel do
    url "https://github.com/lizongying/ungit/releases/download/v0.1.6/ungit_x86_64-apple-darwin"
    sha256 "ed92cbd3e9726d2b92d44ad53712df4df8eb219d908590f466290f2db7d3ae16"
  end

  def install
    binary_name = if Hardware::CPU.arm?
      "ungit_aarch64-apple-darwin"
    else
      "ungit_x86_64-apple-darwin"
    end

    bin.install binary_name => "clone"
    chmod 0755, bin/"clone"
  end

  test do
    system bin/"clone", "lizongying/ungit", testpath/"ungit"
  end
end
