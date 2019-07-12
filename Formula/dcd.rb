class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag      => "v0.12.0",
      :revision => "33dbd7653ecf830b735382e11d9bee66853a6dcf"
  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "3aef244e6e6b1f65e1dbceabd543928e01545ee82438f186eac906fe7d084823" => :mojave
    sha256 "6ab87eabcaed6d879c8cffb83087765c79c28e7cf10ebb8e9fabfa8b63d237ad" => :high_sierra
    sha256 "b3af1626e65317a6a8280b66fdaa5ceda0861b996c54f6542c2f6601374231ae" => :sierra
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    begin
      # spawn a server, using a non-default port to avoid
      # clashes with pre-existing dcd-server instances
      server = fork do
        exec "#{bin}/dcd-server", "-p9167"
      end
      # Give it generous time to load
      sleep 0.5
      # query the server from a client
      system "#{bin}/dcd-client", "-q", "-p9167"
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
